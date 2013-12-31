/*------------------------------------------------------------------------------------*/
//
//  URLRequest.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2010,2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JAMAlert.h"
#import "JSON.h"
#import "JAM.h"

/*------------------------------------------------------------------------------------*/
// Types
/*------------------------------------------------------------------------------------*/

typedef enum
{
	kRequestTypeIssue = 0,
	kRequestTypePost,
} RequestType;

/*------------------------------------------------------------------------------------*/
// Interface
/*------------------------------------------------------------------------------------*/

@interface JAMURLRequest : NSObject

/*------------------------------------------------------------------------------------*/
// Properties
/*------------------------------------------------------------------------------------*/

@property (nonatomic, copy) NSURL * url;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * postData;
@property (nonatomic, copy) NSString * identifier;
@property (nonatomic, copy) NSString * destinationPath;

@property (nonatomic, copy) void(^failedBlock)(JAMURLRequest* a_request, NSError* a_error);
@property (nonatomic, copy) void(^responseBlock)(JAMURLRequest* a_request, NSURLResponse* a_response);
@property (nonatomic, copy) void(^finishedLoadingBlock)(JAMURLRequest* a_request, NSMutableData* a_resultBuffer);
@property (nonatomic, copy) void(^cancelledAuthenticationChallengeBlock)(JAMURLRequest* a_request, NSURLAuthenticationChallenge* a_challenge);

@property (nonatomic, assign) NSTimeInterval defaultTimeOutInterval;
@property (nonatomic, assign) NSInteger defaultRetryCount;
@property (nonatomic, assign) NSInteger retries;

@property (nonatomic, assign) BOOL useMd5Encryption;
@property (nonatomic, assign) BOOL displayAlerts;

@property (nonatomic, assign, readonly) BOOL validUrlResponse;
@property (nonatomic, assign, readonly) RequestType requestType;

/*------------------------------------------------------------------------------------*/
// Class Methods
/*------------------------------------------------------------------------------------*/

+ (BOOL)isValidUrlResponse:(NSURLResponse*)a_urlResponse;

/*------------------------------------------------------------------------------------*/
// Instance Methods
/*------------------------------------------------------------------------------------*/

- (id)initWithUrl:(NSURL*)a_url;
- (void)cancel;
- (void)issue;
- (void)post;

/*------------------------------------------------------------------------------------*/

@end
