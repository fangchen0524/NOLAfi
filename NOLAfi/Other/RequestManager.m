/*------------------------------------------------------------------------------------*/
//
//  RequestManager.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/17/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "RequestManager.h"
#import "AppDelegate.h"
#import "JAMAlert.h"
#import "NSData+Save.h"
#import "HomeViewController.h"
#import "JAMURLRequest.h"

/*------------------------------------------------------------------------------------*/

static NSInteger _instanceCount;

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
/*------------------------------------------------------------------------------------*/

@implementation RequestManager

/*------------------------------------------------------------------------------------*/
#pragma mark - Class Methods
/*------------------------------------------------------------------------------------*/

+ (RequestManager*)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
	
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
	
    return sharedInstance;
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Instance Methods
/*------------------------------------------------------------------------------------*/

- (id)init
{
	NSAssert((_instanceCount == 0), @">> [ERROR] RequestManager is a singleton class! Use SharedInstance if you wish to use this object. <<");
	
	self = [super init];
	if (self)
	{
		_instanceCount++;
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (JAMURLRequest*)createRequestWithUrl:(NSURL*)a_url
						  successBlock:(RequestResponseBlock)a_successBlock
						  failureBlock:(RequestResponseBlock)a_failureBlock
{
	// Instantiate request
	JAMURLRequest * request = [[JAMURLRequest alloc] initWithUrl:a_url];
	if (request)
	{
		// Finished block
		request.finishedLoadingBlock = ^(JAMURLRequest* a_request, NSMutableData* a_data){
			// Process response data
			NSString * responseString = [[NSString alloc] initWithData:a_data encoding:NSUTF8StringEncoding];
			SBJSON * json = [[SBJSON alloc] init];
			NSError * error = nil;
			id result = [json objectWithString:responseString error:&error];
			if (!error)
			{
				if ([[result objectForKey:@"status"] intValue] == 200)
				{
					// Call success block
					a_successBlock([NSDictionary dictionaryWithObject:result forKey:@"success"]);
				}
				else
				{
					// Call success block with errors
					a_successBlock([NSDictionary dictionaryWithObject:[result objectForKey:@"status_reason"] forKey:@"error"]);
				}
			}
			else
			{
				// Call success block with errors
				a_successBlock([NSDictionary dictionaryWithObject:[result objectForKey:@"status_reason"] forKey:@"error"]);
			}
		};

		// Failed block
		request.failedBlock = ^(JAMURLRequest* a_request, NSError* a_error){
			// Call failure block
			a_failureBlock([NSDictionary dictionaryWithObject:a_error forKey:@"failure"]);
		};
	}
	
	return request;
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Status Request
/*------------------------------------------------------------------------------------*/

- (void)requestStatus:(RequestResponseBlock)a_successBlock
		 failureBlock:(RequestResponseBlock)a_failureBlock
{
	NSAssert(a_successBlock, @">> requestStatus: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestStatus: No failure block was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/status"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@", kNolaAPIKey]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Login Request
/*------------------------------------------------------------------------------------*/

- (void)requestLogin:(RequestResponseBlock)a_successBlock
		failureBlock:(RequestResponseBlock)a_failureBlock
			  params:(NSDictionary*)a_paramsDict
{
	NSAssert(a_successBlock, @">> requestLogin: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestLogin: No failure block was specified! <<");
	NSAssert(a_paramsDict, @">> requestLogin: No params dictionary was specified! <<");
	NSAssert([a_paramsDict objectForKey:@"username"], @">> requestLogin: No 'username' key in params dictionary! <<");
	NSAssert([a_paramsDict objectForKey:@"password"], @">> requestLogin: No 'password' key in params dictionary! <<");

	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/login"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@&username=%@&password=%@",
							  kNolaAPIKey,
							  [a_paramsDict objectForKey:@"username"],
							  [a_paramsDict objectForKey:@"password"]]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Registration Request
/*------------------------------------------------------------------------------------*/

- (void)requestRegistration:(RequestResponseBlock)a_successBlock
			   failureBlock:(RequestResponseBlock)a_failureBlock
					 params:(NSDictionary*)a_paramsDict
{
	NSAssert(a_successBlock, @">> requestLogin: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestLogin: No failure block was specified! <<");
	NSAssert(a_paramsDict, @">> requestLogin: No params dictionary was specified! <<");
	NSAssert([a_paramsDict objectForKey:@"username"], @">> requestLogin: No 'username' key in params dictionary! <<");
	NSAssert([a_paramsDict objectForKey:@"password"], @">> requestLogin: No 'password' key in params dictionary! <<");
	NSAssert([a_paramsDict objectForKey:@"email"], @">> requestLogin: No 'email' key in params dictionary! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/register"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@&username=%@&password=%@&email=%@",
							  kNolaAPIKey,
							  [a_paramsDict objectForKey:@"username"],
							  [a_paramsDict objectForKey:@"password"],
							  [a_paramsDict objectForKey:@"email"]]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Places Request
/*------------------------------------------------------------------------------------*/

- (void)requestPlaces:(RequestResponseBlock)a_successBlock
		 failureBlock:(RequestResponseBlock)a_failureBlock
{
	NSAssert(a_successBlock, @">> requestPlaces: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestPlaces: No failure block was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/places"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@", kNolaAPIKey]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - WWOZ Venues Request
/*------------------------------------------------------------------------------------*/

- (void)requestWWOZVenues:(RequestResponseBlock)a_successBlock
			 failureBlock:(RequestResponseBlock)a_failureBlock
{
	NSAssert(a_successBlock, @">> requestWWOZVenues: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestWWOZVenues: No failure block was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/wwoz_venues"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@", kNolaAPIKey]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - WWOZ Events Request
/*------------------------------------------------------------------------------------*/

- (void)requestWWOZEvents:(RequestResponseBlock)a_successBlock
			 failureBlock:(RequestResponseBlock)a_failureBlock
					 date:(NSString*)a_date
{
	NSAssert(a_successBlock, @">> requestWWOZEvents: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestWWOZEvents: No failure block was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/wwoz_events"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		NSString * date = a_date;
		if (isNSStringEmptyOrNil(date))
		{
			NSCalendar * calendar = [NSCalendar currentCalendar];
			NSUInteger unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
			NSDateComponents * dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
			date = [NSString stringWithFormat:@"%i-%02i-%02i", dateComponents.year, dateComponents.month, dateComponents.day];
		}
		[request setPostData:[NSString stringWithFormat:@"key=%@&date=%@",
							  kNolaAPIKey,
							  date]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Artists Request
/*------------------------------------------------------------------------------------*/

- (void)requestArtists:(RequestResponseBlock)a_successBlock
		  failureBlock:(RequestResponseBlock)a_failureBlock
{
	NSAssert(a_successBlock, @">> requestWWOZEvents: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestWWOZEvents: No failure block was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/artists"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@", kNolaAPIKey]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Bus Report Request
/*------------------------------------------------------------------------------------*/

- (void)requestBusReport:(RequestResponseBlock)a_successBlock
			failureBlock:(RequestResponseBlock)a_failureBlock
				 busName:(NSString*)a_busName
{
	NSAssert(a_successBlock, @">> requestBusReport: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestBusReport: No failure block was specified! <<");
	NSAssert(a_busName, @">> requestBusReport: No bus name was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/bus_report"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];
		
		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@&name=%@&lat=%f&lng=%f",
							  kNolaAPIKey,
							  a_busName,
							  ((AppDelegate*)[AppDelegate sharedDelegate]).currLocation.coordinate.latitude,
							  ((AppDelegate*)[AppDelegate sharedDelegate]).currLocation.coordinate.longitude]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Busses Request
/*------------------------------------------------------------------------------------*/

- (void)requestBusses:(RequestResponseBlock)a_successBlock
		 failureBlock:(RequestResponseBlock)a_failureBlock
{
	NSAssert(a_successBlock, @">> requestBusses: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestBusses: No failure block was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/busses"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];

		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@",
							  kNolaAPIKey]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Order Save Request
/*------------------------------------------------------------------------------------*/

- (void)requestOrderSave:(RequestResponseBlock)a_successBlock
			failureBlock:(RequestResponseBlock)a_failureBlock
			   fieldDict:(NSDictionary*)a_fieldDict;
{
	NSAssert(a_successBlock, @">> requestOrderSave: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestOrderSave: No failure block was specified! <<");
	NSAssert(a_fieldDict, @">> requestOrderSave: No field dictionary was specified! <<");
	
	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/order_save"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];

		// Post request (append keys and values from a_fieldDict)
		NSString * postData = [NSString stringWithFormat:@"key=%@", kNolaAPIKey];
		for (NSString * key in [a_fieldDict allKeys])
		{
			postData = [postData stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [a_fieldDict objectForKey:key]]];
		}
		[request setPostData:postData];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Order Save Request
/*------------------------------------------------------------------------------------*/

- (void)requestProducts:(RequestResponseBlock)a_successBlock
		   failureBlock:(RequestResponseBlock)a_failureBlock
{
	NSAssert(a_successBlock, @">> requestOrderSave: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestOrderSave: No failure block was specified! <<");

	NSURL * url = [[NSURL alloc] initWithScheme:@"http"
										   host:kNolaHostAddress
										   path:@"/products"];
	if (url)
	{
		// Create request
		JAMURLRequest * request = [self createRequestWithUrl:url successBlock:a_successBlock failureBlock:a_failureBlock];

		// Post request
		[request setPostData:[NSString stringWithFormat:@"key=%@",
							  kNolaAPIKey]];
		[request post];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Request an image for an image view
/*------------------------------------------------------------------------------------*/

- (BOOL)requestImage:(RequestResponseBlock)a_successBlock
		failureBlock:(RequestResponseBlock)a_failureBlock
		imageUrlPath:(NSString*)a_imageUrlPath
{
	NSAssert(a_successBlock, @">> requestImage: No success block was specified! <<");
	NSAssert(a_failureBlock, @">> requestImage: No failure block was specified! <<");
	
	__block NSString * destinationPath = @"Images";
	__block NSString * fileName = [a_imageUrlPath lastPathComponent];
	
	if (isNSStringEmptyOrNil(fileName))
	{
		// No image was specified
		return NO;
	}
	
	NSString * file = [fileName stringByDeletingPathExtension];
	NSString * ext = [fileName pathExtension];
	NSString * filePath = [JAMAppDelegate obtainResourcePath:file ofType:ext searchPathDirectory:NSDocumentDirectory destinationPath:destinationPath overWrite:NO];
	UIImage * image = [UIImage imageWithContentsOfFile:filePath];
	
	// Does the image already exist locally? If not, then request it.
	if (image)
	{
		// Call success block
		a_successBlock([NSDictionary dictionaryWithObject:
						[NSDictionary dictionaryWithObject:image forKey:@"image"] forKey:@"success"]);
	}
	else
	{
		// Instantiate Request
		JAMURLRequest * request = [[JAMURLRequest alloc] initWithUrl:[NSURL URLWithString:a_imageUrlPath]];
		if (!request)
		{
			return NO;
		}
		
		// Set destination path
		request.destinationPath = destinationPath;
		
		// Finished Block
		request.finishedLoadingBlock = ^(JAMURLRequest* a_request, NSMutableData* a_data){
			if (a_data)
			{
				// Save image data
				UIImage * image = [a_data saveAsImage:fileName
									  destinationPath:a_request.destinationPath
											overWrite:YES];
				
				// Call success block
				a_successBlock([NSDictionary dictionaryWithObject:
								[NSDictionary dictionaryWithObject:image forKey:@"image"] forKey:@"success"]);
			}
		};
			
		// Failed Block
		request.failedBlock = ^(JAMURLRequest* a_request, NSError* a_error){
			// Call failure block
			a_failureBlock([NSDictionary dictionaryWithObject:[a_error localizedDescription] forKey:@"error"]);
		};
		
		// Issue Request
		[request issue];
	}

	return YES;
}

/*------------------------------------------------------------------------------------*/

@end
