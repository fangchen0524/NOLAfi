/*------------------------------------------------------------------------------------*/
//
//  JAMAppDelegate.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAM.h"
#import "RequestManager.h"
#import "JAMBusyView.h"

/*------------------------------------------------------------------------------------*/
// Interface
/*------------------------------------------------------------------------------------*/

@interface JAMAppDelegate : UIResponder <UIApplicationDelegate>

/*------------------------------------------------------------------------------------*/
// Properties
/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) UIWindow * window;

@property (nonatomic, strong, readonly) JAMBusyView * busyView;

/*------------------------------------------------------------------------------------*/
// Class Methods
/*------------------------------------------------------------------------------------*/

// Shared delegate
+ (id)sharedDelegate;

// Sounds
+ (void)playSound:(NSString*)a_fName ext:(NSString*)a_ext;

// Resources
+ (NSString*)obtainResourcePath:(NSString*)a_fileName ofType:(NSString*)a_ofType searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite;
+ (NSString*)saveResource:(NSString*)a_fileName ofType:(NSString*)a_ofType data:(id)a_data searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite;

// pLists
+ (NSMutableDictionary*)loadPlistDictionary:(NSString*)a_fileName searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite;
+ (NSMutableArray*)loadPlistArray:(NSString*)a_fileName searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite;
+ (BOOL)savePlist:(NSMutableDictionary*)a_data fileName:(NSString*)a_fileName searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite;

// Bundles
+ (NSBundle*)loadBundle:(NSString*)a_bundleName;
+ (BOOL)resourceInBundle:(NSString*)a_fileName ofType:(NSString*)a_ofType bundleName:(NSString*)a_bundleName;

// Images
+ (UIImage*)resizeImage:(UIImage*)a_image newSize:(CGSize)a_newSize;

// Maps
+ (void)animateMapToLocation:(MKMapView*)a_mapView location:(CLLocationCoordinate2D)a_location;

/*------------------------------------------------------------------------------------*/
// Instance Methods
/*------------------------------------------------------------------------------------*/

// URL commands
- (BOOL)handleURLCmd:(NSURL*)a_url;

// Busy
- (BOOL)displayBusyView;
- (BOOL)showBusyView;
- (BOOL)showBusyViewWithText:(NSString*)a_text;
- (void)hideBusyView;

/*------------------------------------------------------------------------------------*/

@end
