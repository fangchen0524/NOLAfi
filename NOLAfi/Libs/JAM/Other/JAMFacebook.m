/*------------------------------------------------------------------------------------*/
//
//  JAMFacebook.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMFacebook.h"
#import "JAMAlert.h"
#import "NSData+Save.h"

/*------------------------------------------------------------------------------------*/

@implementation JAMFacebook

/*------------------------------------------------------------------------------------*/
// Pragma Ignores
/*------------------------------------------------------------------------------------*/

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

/*------------------------------------------------------------------------------------*/
// Facebook
/*------------------------------------------------------------------------------------*/

- (BOOL)authenticate
{
	BOOL returnValue = NO;
	
	if (!self.facebook)
	{
		self.facebook = [[Facebook alloc] initWithAppId:kFacebookAppID andDelegate:self];
	}
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	if (([defaults objectForKey:@"FBAccessTokenKey"]) &&
		([defaults objectForKey:@"FBExpirationDateKey"]))
	{
		self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
		self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
	
	// Is session valid?
	if (![self.facebook isSessionValid])
	{
		// Authorize
		[self.facebook authorize:[NSArray arrayWithObjects:
								  @"email",
								  @"user_about_me",
								  @"user_interests",
								  @"user_activities",
								  @"user_likes",
								  @"user_location",
								  @"user_birthday",
								  @"user_hometown",
								  nil]];
	}
	else
	{
		[self requestUserData];
		
		returnValue = YES;
	}
	
	// Save off facebook auth key value
	[defaults setBool:YES forKey:kFacebookAuthenticationKey];
    [defaults synchronize];
	
	return returnValue;
}

/*------------------------------------------------------------------------------------*/

- (void)requestUserData
{
	NSString * query = @"SELECT uid, first_name, last_name, middle_name, pic_small, pic_big, sex, birthday, birthday_date, hometown_location, email, current_location, activities, interests, music, tv, movies, books, quotes, sports, languages FROM user WHERE uid=me()";
	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									query, @"query",
									nil];
	[self.facebook requestWithMethodName:@"fql.query"
							   andParams:params
						   andHttpMethod:@"GET"
							 andDelegate:self];
}

/*------------------------------------------------------------------------------------*/
// Facebook Delegate
/*------------------------------------------------------------------------------------*/

- (void)fbDidLogin
{
	debug NSLog(@">> FacebookDelegate::fbDidLogin <<");
	
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
	// Request user data
	[self requestUserData];
}

/*------------------------------------------------------------------------------------*/

- (void)fbDidNotLogin:(BOOL)cancelled
{
	debug NSLog(@">> FacebookDelegate::fbDidNotLogin <<");
	
	// Post facebook did not login notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kFacebookDidNotLoginNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
	debug NSLog(@">> FacebookDelegate::fbDidExtendToken <<");
}

/*------------------------------------------------------------------------------------*/

- (void)fbDidLogout
{
	debug NSLog(@">> FacebookDelegate::fbDidLogout <<");
}

/*------------------------------------------------------------------------------------*/

- (void)fbSessionInvalidated
{
	debug NSLog(@">> FacebookDelegate::fbSessionInvalidated <<");
}

/*------------------------------------------------------------------------------------*/
// Facebook Request Delegate
/*------------------------------------------------------------------------------------*/

- (void)requestLoading:(FBRequest *)request
{
	debug NSLog(@">> FacebookRequestDelegate::requestLoading <<");
}

/*------------------------------------------------------------------------------------*/

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	debug NSLog(@">> FacebookRequestDelegate::didReceiveResponse <<");
}

/*------------------------------------------------------------------------------------*/

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	debug NSLog(@">> FacebookRequestDelegate::didFailWithError: %@ <<", [error localizedDescription]);

	// Hide busy
	id delegate = [[UIApplication sharedApplication] delegate];
	SEL selector = @selector(hideBusyView);
	if ([delegate respondsToSelector:selector])
	{
		[delegate performSelector:selector];
	}
	
	// Post facebook did not login notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kFacebookDidNotLoginNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)request:(FBRequest *)request didLoad:(id)result
{
	debug NSLog(@">> FacebookRequestDelegate::didLoad <<");
	
	if ([result isKindOfClass:[NSArray class]])
	{
		NSArray * array = (NSArray*)result;
		NSMutableDictionary * dict = [[array objectAtIndex:0] mutableCopy];
		
		// Handle Null Objects (Fix for crash)
		for (NSString * key in dict.allKeys)
		{
			if ([dict objectForKey:key] == [NSNull null])
			{
				[dict setObject:@"" forKey:key];
			}
		}
		
		// Save user data
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:dict forKey:kFacebookUserDataKey];
		[defaults synchronize];

		// Request big picture
		NSURL * pictureUrl = [NSURL URLWithString:[dict objectForKey:@"pic_big"]];
		
		// Instantiate Request
		JAMURLRequest * request = [[JAMURLRequest alloc] initWithUrl:pictureUrl];
		request.destinationPath = @"Facebook";
		
		// Finished Block
		request.finishedLoadingBlock = ^(JAMURLRequest* a_request, NSMutableData* a_data){
			debug NSLog(@">> JAMFaceBook::pictureFinishedLoading <<");
			
			// Save image to Documents/Facebook
			NSString * fileName = [a_request.url lastPathComponent];
			UIImage * image = [a_data saveAsImage:fileName
								  destinationPath:a_request.destinationPath
										overWrite:YES];
			
			// Post facebook picture notification
			[[NSNotificationCenter defaultCenter] postNotificationName:kFacebookPictureNotification
																object:self
															  userInfo:[NSDictionary dictionaryWithObject:image forKey:@"image"]];
			
			a_request = nil;
		};
		
		// Failed Block
		request.failedBlock = ^(JAMURLRequest* a_request, NSError* a_error){
			debug NSLog(@">> JAMFaceBook::pictureFailed: %@ <<", [a_error localizedDescription]);
			
			a_request = nil;
		};
		
		// Issue Request
		[request issue];

		// Post facebook login notification
		[[NSNotificationCenter defaultCenter] postNotificationName:kFacebookLoginNotification object:self userInfo:nil];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
	debug NSLog(@">> FacebookRequestDelegate::didLoadRawResponse <<");
}

/*------------------------------------------------------------------------------------*/

@end
