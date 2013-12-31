/*------------------------------------------------------------------------------------*/
//
//  RequestManager.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/17/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "JAMURLRequest.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Defines
/*------------------------------------------------------------------------------------*/

// REMOVE-ME
//#define kRequestLoginFinishedNotification			@"kRequestLoginFinishedNotification"
//#define kRequestLoginFailedNotification				@"kRequestLoginFailedNotification"

// REMOVE-ME
//#define kRequestRegistrationFinishedNotification	@"kRequestRegistrationFinishedNotification"
//#define kRequestRegistrationFailedNotification		@"kRequestRegistrationFailedNotification"

// REMOVE-ME
#define kRequestBusReportFinishedNotification		@"kRequestBusReportFinishedNotification"
#define kRequestBusReportFailedNotification			@"kRequestBusReportFailedNotification"

// REMOVE-ME
#define kRequestBussesFinishedNotification			@"kRequestBussesFinishedNotification"
#define kRequestBussesFailedNotification			@"kRequestBussesFailedNotification"

// REMOVE-ME
#define kRequestOrderSaveFinishedNotification		@"kRequestOrderSaveFinishedNotification"
#define kRequestOrderSaveFailedNotification			@"kRequestOrderSaveFailedNotification"

// REMOVE-ME
#define kRequestProductsFinishedNotification		@"kRequestProductsFinishedNotification"
#define kRequestProductsFailedNotification			@"kRequestProductsFailedNotification"

/*------------------------------------------------------------------------------------*/
#pragma mark - Types
/*------------------------------------------------------------------------------------*/

typedef void (^RequestResponseBlock)(id a_result);

/*------------------------------------------------------------------------------------*/
#pragma mark - Interface
/*------------------------------------------------------------------------------------*/

@interface RequestManager : NSObject

/*------------------------------------------------------------------------------------*/
#pragma mark - Properties
/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;

/*------------------------------------------------------------------------------------*/
#pragma mark - Class Methods
/*------------------------------------------------------------------------------------*/

+ (RequestManager*)sharedInstance;

/*------------------------------------------------------------------------------------*/
#pragma mark - Instance Methods
/*------------------------------------------------------------------------------------*/

- (void)requestStatus:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock;
- (void)requestLogin:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock params:(NSDictionary*)a_paramsDict;
- (void)requestRegistration:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock params:(NSDictionary*)a_paramsDict;
- (void)requestPlaces:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock;
- (void)requestWWOZVenues:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock;
- (void)requestWWOZEvents:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock date:(NSString*)a_date;
- (void)requestArtists:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock;
- (void)requestBusReport:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock busName:(NSString*)a_busName;
- (void)requestBusses:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock;
- (void)requestOrderSave:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock fieldDict:(NSDictionary*)a_fieldDict;
- (void)requestProducts:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock;
- (BOOL)requestImage:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock imageUrlPath:(NSString*)a_imageUrlPath;

/*------------------------------------------------------------------------------------*/

@end
