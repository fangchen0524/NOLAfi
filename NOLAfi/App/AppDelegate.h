/*------------------------------------------------------------------------------------*/
//
//  AppDelegate.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAMAppDelegate.h"
#import "JAMFacebook.h"
#import "HomeViewController.h"

/*------------------------------------------------------------------------------------*/

@interface AppDelegate : JAMAppDelegate <CLLocationManagerDelegate>

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) NSDictionary * wwozVenuesDict;
@property (nonatomic, strong) NSDictionary * wwozDateEventsDict;
@property (nonatomic, strong) NSDictionary * bussesDict;
@property (nonatomic, strong) NSDictionary * productsDict;
@property (nonatomic, strong) NSArray * placesArray;
@property (nonatomic, strong) NSArray * artistsArray;
@property (nonatomic, strong) AVPlayer * avPlayer;
@property (nonatomic, strong) CLLocationManager * locationMgr;
@property (nonatomic, strong) CLLocation * currLocation;
@property (nonatomic, strong) NSDate * selectedDate;
@property (nonatomic, strong) HomeViewController * homeController;

@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, assign) BOOL attemptingLogin;

@property (nonatomic, strong, readonly) JAMFacebook * jamFacebook;

/*------------------------------------------------------------------------------------*/

- (void)connectToBackend;
- (void)requestStatus:(RequestResponseBlock)a_block;
- (void)requestLogin:(NSDictionary*)a_paramsDict;
- (void)requestRegistration:(NSDictionary*)a_paramsDict;
- (void)requestWWOZVenues;
- (void)requestPlaces;
- (void)requestWWOZEvents:(NSString*)a_dateString;
- (void)requestBusReport:(NSString*)a_busName;
- (void)requestBusses;
- (void)requestOrderSave:(NSDictionary*)a_fieldDict;
- (void)requestProducts;

- (NSString*)findArtistImageUrlPath:(NSString*)a_artist;
- (BOOL)findImageUrlPathWithEventDict:(NSDictionary*)a_eventDict venueDict:(NSDictionary*)a_venueDict successBlock:(RequestResponseBlock)a_successBlock failureBlock:(RequestResponseBlock)a_failureBlock;

/*------------------------------------------------------------------------------------*/

@end
