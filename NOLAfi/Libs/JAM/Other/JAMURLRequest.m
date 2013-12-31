/*------------------------------------------------------------------------------------*/
//
//  JAMURLRequest.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2010,2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMURLRequest.h"
#import "JAMAppDelegate.h"
#import "NSString+MD5.h"

/*------------------------------------------------------------------------------------*/
// Static
/*------------------------------------------------------------------------------------*/

static NSMutableDictionary * _registeredRequestsDict;

/*------------------------------------------------------------------------------------*/
// Private
/*------------------------------------------------------------------------------------*/

@interface JAMURLRequest() < NSURLConnectionDelegate, NSURLConnectionDataDelegate >
{
	NSURLConnection * _connection;
	NSMutableData * _resultBuffer;
}
@end

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation JAMURLRequest

/*------------------------------------------------------------------------------------*/
// Pragma Ignores
/*------------------------------------------------------------------------------------*/

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

/*----------------------------------------------------------------------------------------------------------*/
// Class Methods
/*----------------------------------------------------------------------------------------------------------*/

+ (BOOL)isValidUrlResponse:(NSURLResponse*)a_urlResponse
{
    if ([a_urlResponse isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)a_urlResponse;
        if ((httpResponse.statusCode < 200) ||
            (httpResponse.statusCode >= 300))
        {
            debug NSLog(@">> isValidUrlResponse: [Status Code = %i '%@'] <<", httpResponse.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]);
            
            return NO;
        }
    }
    
    return YES;
}

/*------------------------------------------------------------------------------------*/

+ (BOOL)registerRequest:(JAMURLRequest*)a_request
{
	if (!_registeredRequestsDict)
	{
		_registeredRequestsDict = [[NSMutableDictionary alloc] init];
	}
	
	NSString * urlPath = [[[a_request url] absoluteString] lowercaseString];
	if (![_registeredRequestsDict objectForKey:urlPath])
	{
		[_registeredRequestsDict setObject:[NSNumber numberWithInteger:1] forKey:urlPath];
		return YES;
	}
	else
	{
		NSNumber * count = [NSNumber numberWithInteger:([[_registeredRequestsDict objectForKey:urlPath] integerValue] + 1)];
		[_registeredRequestsDict setObject:count forKey:urlPath];
	}
	
	return NO;
}

/*------------------------------------------------------------------------------------*/

+ (BOOL)unregisterRequest:(JAMURLRequest*)a_request
{
	NSString * urlPath = [[[a_request url] absoluteString] lowercaseString];
	if ([_registeredRequestsDict objectForKey:urlPath])
	{
		NSNumber * count = [_registeredRequestsDict objectForKey:urlPath];

		debug NSLog(@">> JAMURLRequest::unregisterRequest: [%i] => %@ <<", count.integerValue, urlPath);
		
		[_registeredRequestsDict removeObjectForKey:urlPath];
		
		return YES;
	}
	
	return NO;
}


/*------------------------------------------------------------------------------------*/
// Instance Methods
/*------------------------------------------------------------------------------------*/

- (id)init
{
	NSAssert(0, @">> [ERROR] You must use 'initWithUrl' to initialize a JAMURLRequest! <<");
	
	return nil;
}

/*------------------------------------------------------------------------------------*/

- (id)initWithUrl:(NSURL*)a_url
{
    self = [super init];
    
	if (self)
	{
		self.url = a_url;
		self.defaultTimeOutInterval = 15;
		self.defaultRetryCount = 3;
		self.retries = 0;
		self.useMd5Encryption = NO;
		self.displayAlerts = NO;
		
		[JAMURLRequest registerRequest:self];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (void)dealloc 
{
	[self cancel];
}

/*------------------------------------------------------------------------------------*/

- (void)cancel
{
	if (_connection)
	{
		[_connection cancel];
    }
    _connection = nil;
	
	[JAMURLRequest unregisterRequest:self];

	self.url = nil;
	_resultBuffer = nil;
	self.userName = nil;
	self.password = nil;
	self.failedBlock = nil;
	self.responseBlock = nil;
	self.finishedLoadingBlock = nil;
	self.cancelledAuthenticationChallengeBlock = nil;
}

/*------------------------------------------------------------------------------------*/

- (void)issue
{
    if (!self.url)
    {
		debug NSLog(@">> JAMURLRequest::issue 'No URL specified!' <<");
        return;
    }
    
	_requestType = kRequestTypeIssue;
	
    _resultBuffer = nil;
	_resultBuffer = [[NSMutableData alloc] init];
    
	NSURLRequest * request = [[NSURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.defaultTimeOutInterval];
	if (request)
	{
		_connection = nil;
		_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)post
{
    if (!self.url)
    {
		debug NSLog(@">> JAMURLRequest::post 'No URL specified!' <<");
        return;
    }

	_requestType = kRequestTypePost;
	
    _resultBuffer = nil;
	_resultBuffer = [[NSMutableData alloc] init];
	
	// create mutable request
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:self.url];
	if (request)
	{
		// set GET or POST method
		[request setHTTPMethod:@"POST"];
		// adding keys with values
		NSData * encodedData = [self.postData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString * postLength = [NSString stringWithFormat:@"%d",[encodedData length]];
		[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:encodedData];
		
		_connection = nil;
		_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

/*------------------------------------------------------------------------------------*/

// FIX-ME

- (BOOL)retry
{
/*
	if (self.defaultRetryCount > 0)
	{
		if (++_retries < self.defaultRetryCount)
		{
			debug NSLog(@">> [Retry] %@ <<", [self description]);
			
			if (_requestType == kRequestTypeIssue)
			{
				[self issue];
			}
			else if (_requestType == kRequestTypePost)
			{
				[self post];
			}
			return YES;
		}
	}
*/
	
	return NO;
}

/*------------------------------------------------------------------------------------*/
// Connection Delegate Methods
/*------------------------------------------------------------------------------------*/

- (BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    //return YES to say that we have the necessary credentials to access the requested resource
    if ((self.userName) &&
        (self.password))
    {
        return YES;
    }
    
    return NO;
}

/*------------------------------------------------------------------------------------*/

- (void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge previousFailureCount] == 0)
	{
		NSString * userName = self.userName;
		NSString * password = self.password;
        
		if (self.useMd5Encryption)
		{
			userName = [userName md5EncodedString];
			password = [password md5EncodedString];
		}
		
		NSURLCredential *credential = [NSURLCredential credentialWithUser:userName password:password persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	}
	else
	{
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)a_data 
{
	[_resultBuffer appendData:a_data];
}

/*------------------------------------------------------------------------------------*/

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)a_error 
{
	if ([self retry])
	{
		return;
	}
	
	if (self.failedBlock)
	{
		self.failedBlock(self, a_error);
	}
}

/*------------------------------------------------------------------------------------*/

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)a_response
{
    _validUrlResponse = [JAMURLRequest isValidUrlResponse:a_response];
	
	if (self.responseBlock)
	{
		self.responseBlock(self, a_response);
	}
}

/*------------------------------------------------------------------------------------*/

- (void)connectionDidFinishLoading:(NSURLConnection*)a_connection 
{
	if (self.finishedLoadingBlock)
	{
		self.finishedLoadingBlock(self, _resultBuffer);
	}
}

/*------------------------------------------------------------------------------------*/

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)a_challenge
{
	if (self.cancelledAuthenticationChallengeBlock)
	{
		self.cancelledAuthenticationChallengeBlock(self, a_challenge);
	}
}

/*------------------------------------------------------------------------------------*/

@end
