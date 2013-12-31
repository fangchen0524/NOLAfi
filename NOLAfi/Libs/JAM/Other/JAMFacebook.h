/*------------------------------------------------------------------------------------*/
//
//  JAMFacebook.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "JAM.h"
#import "JAMURLRequest.h"
#import "FBConnect.h"

/*------------------------------------------------------------------------------------*/

#define kFacebookAuthenticationKey			@"kFacebookAuthenticationKey"
#define kFacebookUserDataKey				@"kFacebookUserDataKey"
#define kFacebookLoginNotification			@"kFacebookLoginNotification"
#define kFacebookDidNotLoginNotification	@"kFacebookDidNotLoginNotification"
#define kFacebookPictureNotification		@"kFacebookPictureNotification"
#define kFacebookLoginNotification			@"kFacebookLoginNotification"

/*------------------------------------------------------------------------------------*/

@interface JAMFacebook : NSObject < FBSessionDelegate, FBRequestDelegate >

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) Facebook * facebook;

/*------------------------------------------------------------------------------------*/

- (BOOL)authenticate;

/*------------------------------------------------------------------------------------*/

@end
