/*------------------------------------------------------------------------------------*/
//
//  AppDelegate.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "NSString+Convert.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Defines
/*------------------------------------------------------------------------------------*/

#if DEBUG
	#define TEST_BUS				1
	#define TEST_ARTISTS			0
	#define IGNORE_REGISTRATION		1
#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Interface
/*------------------------------------------------------------------------------------*/

@interface AppDelegate()
{
	BOOL _connectingToBackend;
	BOOL _initBusyView;
}
@end

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
/*------------------------------------------------------------------------------------*/

@implementation AppDelegate

/*------------------------------------------------------------------------------------*/

+ (AppDelegate*)sharedDelegate
{
	return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Override Methods
/*------------------------------------------------------------------------------------*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[super application:application didFinishLaunchingWithOptions:nil];

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

	// Instantiate welcome controller
	WelcomeViewController * controller = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
	controller.view.backgroundColor = [UIColor blackColor];
	self.window.backgroundColor = [UIColor colorWithRed:(47/255) green:(43/255) blue:(36/255) alpha:1.0]; // Brown
	self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];

	// Initialize Location Services
	self.locationMgr = [[CLLocationManager alloc] init];
	self.locationMgr.delegate = self;
	self.locationMgr.distanceFilter = 1.0;
	self.locationMgr.desiredAccuracy = kCLLocationAccuracyKilometer;
	[self.locationMgr startUpdatingLocation];
	
	// Initialize facebook
	_jamFacebook = [[JAMFacebook alloc] init];
	
    return YES;
}

/*------------------------------------------------------------------------------------*/

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.jamFacebook.facebook handleOpenURL:url];
}

/*------------------------------------------------------------------------------------*/

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.jamFacebook.facebook handleOpenURL:url];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Busy View Methods
/*------------------------------------------------------------------------------------*/

- (BOOL)displayBusyView
{
	BOOL rVal = [super displayBusyView];
	
	if (!_initBusyView)
	{
		self.busyView.fadeToAlpha = 1.0;
		self.busyView.backgroundColor = [UIColor clearColor];
		self.busyView.backgroundView.backgroundColor = [UIColor clearColor];
		self.busyView.activityView.hidden = NO;
		self.busyView.activityView.backgroundColor = [UIColor clearColor];
		self.busyView.activityView.layer.cornerRadius = 8;
		self.busyView.activityView.layer.masksToBounds = YES;
		UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.busyView.activityBackgroundImageView.frame];
		imageView.backgroundColor = [UIColor clearColor];
		imageView.image = [UIImage imageNamed:@"filters-overlay.png"];
		[self.busyView.activityView insertSubview:imageView belowSubview:self.busyView.activityBackgroundImageView];
		CGRect frame = self.busyView.activityBackgroundImageView.frame;
		frame.size.height /= 2.0;
		self.busyView.activityBackgroundImageView.frame = frame;
		self.busyView.activityBackgroundImageView.backgroundColor = [UIColor clearColor];
		self.busyView.activityBackgroundImageView.hidden = NO;
		self.busyView.activityBackgroundImageView.contentMode =  UIViewContentModeScaleAspectFit;
		self.busyView.activityBackgroundImageView.image = [UIImage imageNamed:@"nolafi-shadow.png"];
		frame = self.busyView.activityIndicatorView.frame;
		frame.origin.y += 15;
		self.busyView.activityIndicatorView.frame = frame;
		self.busyView.activityIndicatorView.backgroundColor = [UIColor clearColor];
		frame = self.busyView.activityLabel.frame;
		frame.origin.y += 15;
		self.busyView.activityLabel.frame = frame;
		self.busyView.activityLabel.backgroundColor = [UIColor clearColor];
		
		_initBusyView = YES;
	}
	
	return rVal;
}

/*------------------------------------------------------------------------------------*/

- (BOOL)showBusyView
{
	if ([super showBusyView])
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			self.busyView.activityView.alpha = 0.0;
			[UIView animateWithDuration:0.33
							 animations:^{
								 self.busyView.activityView.alpha = 1.0;
							 }
			 ];
		});
		
		return YES;
	}
	
	return NO;
}

/*------------------------------------------------------------------------------------*/

- (BOOL)showBusyViewWithText:(NSString*)a_text
{
	if ([super showBusyViewWithText:a_text])
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			self.busyView.activityView.alpha = 0.0;
			[UIView animateWithDuration:0.33
							 animations:^{
								 self.busyView.activityView.alpha = 1.0;
							 }
			 ];
		});
		
		return YES;
	}
	
	return NO;
}

/*------------------------------------------------------------------------------------*/

- (void)hideBusyView
{
	[super hideBusyView];

	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.33
						 animations:^{
							 self.busyView.activityView.alpha = 0.0;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/
#pragma mark - CLLocationManagerDelegate Methods
/*------------------------------------------------------------------------------------*/

- (void)locationManager:(CLLocationManager*)a_manager didUpdateToLocation:(CLLocation*)a_newLocation fromLocation:(CLLocation*)a_oldLocation
{
	// Test with center in New Orleans
	self.currLocation = [[CLLocation alloc] initWithLatitude:29.9528 longitude:-90.0661];
	
#if TEST_BUS
	[self requestBusReport:@"Test_Bus"];
#endif // #if TEST_BUS
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Backend Connection Methods
/*------------------------------------------------------------------------------------*/

- (void)connectToBackend
{
	if (_connectingToBackend)
	{
		return;
	}

	_connectingToBackend = YES;
	
	// Request NOLA status
	[self requestStatus:^(id a_result){
		// Request WWOZ Venues
		[self requestWWOZVenues];
		
	}];
}

/*------------------------------------------------------------------------------------*/

- (void)requestStatus:(RequestResponseBlock)a_block
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Status..."];
	
	[[RequestManager sharedInstance]
	 requestStatus:^(id a_result){
		 NSString * error = [a_result objectForKey:@"error"];
		 if (!isNSStringEmptyOrNil(error))
		 {
			 [self requestFailed:@"Status" error:error];
		 }
		 else if (a_block)
		 {
			 a_block(nil);
		 }
	 }
	 failureBlock:^(id a_result){
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [self requestFailed:@"Status" error:error];
	 }
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestLogin:(NSDictionary*)a_paramsDict;
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Login..."];
	
	[[RequestManager sharedInstance]
	 requestLogin:^(id a_result){
		 NSString * error = [a_result objectForKey:@"error"];
		 if (!isNSStringEmptyOrNil(error))
		 {
			 [self requestFailed:@"Login" error:error];
		 }
	 }
	 failureBlock:^(id a_result){
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [self requestFailed:@"Login" error:error];
	 }
	 params:a_paramsDict
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestRegistration:(NSDictionary*)a_paramsDict;
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Register..."];
	
	[[RequestManager sharedInstance]
	 requestRegistration:^(id a_result){
		 NSString * error = [a_result objectForKey:@"error"];
		 if ((!isNSStringEmptyOrNil(error))
#if IGNORE_REGISTRATION
			 &&
			 (![error isEqualToString:@"Registration failed. Username already exists. Please choose another username."]))
#else
			 )
#endif
		 {
			 [self requestFailed:@"Registration" error:error];
		 }
		 else
		 {
			 // Dismiss registration controller
			 [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
		 }
	 }
	 failureBlock:^(id a_result){
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [self requestFailed:@"Registration" error:error];
	 }
	 params:a_paramsDict
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestWWOZVenues
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Venues..."];
	
	[[RequestManager sharedInstance]
	 requestWWOZVenues:^(id a_result){
		 NSString * error = [a_result objectForKey:@"error"];
		 if (!isNSStringEmptyOrNil(error))
		 {
			 [[AppDelegate sharedDelegate] setWwozVenuesDict:nil];
			 [self requestFailed:@"WWOZ Venues" error:error];
		 }
		 else
		 {
			 NSAssert([[[a_result objectForKey:@"success"] objectForKey:@"data"] isKindOfClass:[NSDictionary class]], @">> AppDelegate::requestWWOZVenues: Data is not a dictionary! <<");
			 
			 // Save off venues dictionary
			 [[AppDelegate sharedDelegate] setWwozVenuesDict:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
			 
			 // Are we doing a connection to the backend?
			 if (_connectingToBackend)
			 {
				 // Request places
				 [self requestPlaces];
			 }
		 }
	 }
	 failureBlock:^(id a_result){
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [[AppDelegate sharedDelegate] setWwozVenuesDict:nil];
		 [self requestFailed:@"WWOZ Venues" error:error];
	 }
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestPlaces
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Places..."];
	
	[[RequestManager sharedInstance]
	 requestPlaces:^(id a_result){
		 NSString * error = [a_result objectForKey:@"error"];
		 if (!isNSStringEmptyOrNil(error))
		 {
			 [[AppDelegate sharedDelegate] setPlacesArray:nil];
			 [self requestFailed:@"Places" error:error];
		 }
		 else
		 {
			 NSAssert([[[a_result objectForKey:@"success"] objectForKey:@"data"] isKindOfClass:[NSArray class]], @">> AppDelegate::requestPlaces: Data is not an array! <<");
			 
			 // Save off venues dictionary
			 [((AppDelegate*)[AppDelegate sharedDelegate]) setPlacesArray:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
			 
			 // Are we doing a connection to the backend?
			 if (_connectingToBackend)
			 {
				 // Request Artists
				 [self requestArtists];
			 }
		 }
	 }
	 failureBlock:^(id a_result){
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [[AppDelegate sharedDelegate] setPlacesArray:nil];
		 [self requestFailed:@"Places" error:error];
	 }
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestWWOZEvents:(NSString*)a_dateString
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Events..."];
	
	__block NSString * dateString = a_dateString;
	
	[[RequestManager sharedInstance]
	 requestWWOZEvents:^(id a_result){
		 [[AppDelegate sharedDelegate] setWwozDateEventsDict:nil];
		 
		 NSString * error = [a_result objectForKey:@"error"];
		 if (!isNSStringEmptyOrNil(error))
		 {
			 [self requestFailed:@"WWOZ Events" error:error];
		 }
		 else
		 {
			 id data = [[a_result objectForKey:@"success"] objectForKey:@"data"];
			 if (([data isKindOfClass:[NSArray class]]) &&
				 ([data count] == 0))
			 {
				 [self requestFailed:@"WWOZ Events" error:[NSString stringWithFormat:@"No events available for: %@!", dateString]];
			 }
			 else
			 {
				 NSAssert([[[a_result objectForKey:@"success"] objectForKey:@"data"] isKindOfClass:[NSDictionary class]], @">> AppDelegate::requestWWOZEvents: Data is not a dictionary! <<");
				 
				 // Save off WWOZ events dictionary
				 [[AppDelegate sharedDelegate] setWwozDateEventsDict:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
			 }
			 
			 // Are we doing a connection to the backend?
			 if (_connectingToBackend)
			 {
				 // If this is the first time running, get rid of welcome and present home screen
				 static dispatch_once_t once;
				 dispatch_once(&once, ^{
					 // Get rid of Welcome screen
					 [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
					 
					 // Bring up home screen
					 [self presentHomeScreen];
				 });
				 
				 _connectingToBackend = NO;
			 }
			 else
			 {
				 [[AppDelegate sharedDelegate] hideBusyView];
			 }
			 
			 // Post Notification
			 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestWWOZEventsNotification object:self userInfo:nil];
		 }
	 }
	 failureBlock:^(id a_result){
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [[AppDelegate sharedDelegate] setWwozDateEventsDict:nil];
		 [self requestFailed:@"WWOZ Events" error:error];
	 }
	 date:a_dateString
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestArtists
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Artists..."];
	
	[[RequestManager sharedInstance]
	 requestArtists:^(id a_result){
		 NSString * error = [a_result objectForKey:@"error"];
		 if (!isNSStringEmptyOrNil(error))
		 {
			 [[AppDelegate sharedDelegate] setArtistsArray:nil];
			 [self requestFailed:@"Artists" error:error];
		 }
		 else
		 {
			 NSAssert([[[a_result objectForKey:@"success"] objectForKey:@"data"] isKindOfClass:[NSArray class]], @">> AppDelegate::requestArtists: Data is not an array! <<");
			 
			 // Save artists array
			 [[AppDelegate sharedDelegate] setArtistsArray:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
		
#if TEST_ARTISTS
			 for (NSDictionary * artist in self.artistsArray)
			 {
				 debug NSLog(@">> Artist => %@ <<", [artist objectForKey:@"name"]);
			 }
#endif // #if DEBUG
			 
			 // Are we doing a connection to the backend?
			 if (_connectingToBackend)
			 {
				 // Request WWOZ events
				 [self requestWWOZEvents:nil];
			 }
		 }
	 }
	 failureBlock:^(id a_result){
		 [[AppDelegate sharedDelegate] setArtistsArray:nil];
		 
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [[AppDelegate sharedDelegate] setArtistsArray:nil];
		 [self requestFailed:@"Artists" error:error];
	 }
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestBusReport:(NSString*)a_busName
{
	[[RequestManager sharedInstance]
	 requestBusReport:^(id a_result){
		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestBusReportFinishedNotification
															 object:self
														   userInfo:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
	 }
	 failureBlock:^(id a_result){
		 [[AppDelegate sharedDelegate] hideBusyView];
		 
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [self requestFailed:@"Bus Report" error:error];
		 
		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestBusReportFailedNotification
															 object:self
														   userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
	 }
	 busName:a_busName
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestBusses
{
	[[RequestManager sharedInstance]
	 requestBusses:^(id a_result){
		 [[AppDelegate sharedDelegate] hideBusyView];
		 
		 // Save off data
		 [[AppDelegate sharedDelegate] setBussesDict:[[a_result objectForKey:@"success"] objectForKey:@"data"]];

		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestBussesFinishedNotification
															 object:self
														   userInfo:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
	 }
	 failureBlock:^(id a_result){
		 [[AppDelegate sharedDelegate] hideBusyView];

		 // Clear data
		 [[AppDelegate sharedDelegate] setBussesDict:nil];
		 
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [self requestFailed:@"Bus Report" error:error];
		 
		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestBussesFailedNotification
															 object:self
														   userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
	 }
	 ];
};

/*------------------------------------------------------------------------------------*/

- (void)requestOrderSave:(NSDictionary*)a_fieldDict
{
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Saving order..."];
	
	[[RequestManager sharedInstance]
	 requestOrderSave:^(id a_result){
		 [[AppDelegate sharedDelegate] hideBusyView];
		 
		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestOrderSaveFinishedNotification
															 object:self
														   userInfo:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
	 }
	 failureBlock:^(id a_result){
		 [[AppDelegate sharedDelegate] hideBusyView];
		 
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [self requestFailed:@"Bus Report" error:error];

		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestOrderSaveFailedNotification
															 object:self
														   userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
	 }
	 fieldDict:a_fieldDict
	 ];
}

/*------------------------------------------------------------------------------------*/

- (void)requestProducts
{
	[[RequestManager sharedInstance]
	 requestProducts:^(id a_result){
		 // Save off data
		 [[AppDelegate sharedDelegate] setProductsDict:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
		
		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestProductsFinishedNotification
															object:self
														  userInfo:[[a_result objectForKey:@"success"] objectForKey:@"data"]];
	 }
	 failureBlock:^(id a_result){
		 [[AppDelegate sharedDelegate] setProductsDict:nil];
		 
		 NSString * error = [a_result objectForKey:@"failure"];
		 if (isNSStringEmptyOrNil(error))
		 {
			 error = @"Unknown error type";
		 }
		 [self requestFailed:@"Products" error:error];

		 // Post notification for listeners
		 [[NSNotificationCenter defaultCenter] postNotificationName:kRequestProductsFailedNotification
															 object:self
														   userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
	 }
	 ];
}

/*------------------------------------------------------------------------------------*/

- (NSString*)findArtistImageUrlPath:(NSString*)a_artist
{
	for (NSDictionary * artist in self.artistsArray)
	{
		if ([[[[artist objectForKey:@"name"] lowercaseString] flattenHTML] isEqualToString:[[a_artist lowercaseString] flattenHTML]])
		{
			NSArray * images = [artist objectForKey:@"images"];
			for (NSDictionary * image in images)
			{
				NSString * imageUrlPath = [image objectForKey:@"image"];
				if (!isNSStringEmptyOrNil(imageUrlPath))
				{
//					debug NSLog(@">> artistImageUrlPath = %@ <<", [imageUrlPath lastPathComponent]);
					return imageUrlPath;
				}
			}
		}
	}
	
	return nil;
}

/*------------------------------------------------------------------------------------*/

- (BOOL)findImageUrlPathWithEventDict:(NSDictionary*)a_eventDict
							venueDict:(NSDictionary*)a_venueDict
						 successBlock:(RequestResponseBlock)a_successBlock
						 failureBlock:(RequestResponseBlock)a_failureBlock
{
	NSString * imageUrlPath = [self findArtistImageUrlPath:[a_eventDict objectForKey:@"title"]];
	if (![[RequestManager sharedInstance] requestImage:a_successBlock failureBlock:a_failureBlock imageUrlPath:imageUrlPath])
	{
		if (![[RequestManager sharedInstance] requestImage:a_successBlock failureBlock:a_failureBlock imageUrlPath:[a_eventDict objectForKey:@"lead_image"]])
		{
			if (![[RequestManager sharedInstance] requestImage:a_successBlock failureBlock:a_failureBlock imageUrlPath:[a_venueDict objectForKey:@"lead_image"]])
			{
				return NO;
			}
		}
	}
	
	return YES;
}

/*------------------------------------------------------------------------------------*/

- (void)presentHomeScreen
{
	[[AppDelegate sharedDelegate] hideBusyView];
	
	// Instantiate Home View Controller
	HomeViewController * controller = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
	UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
	navController.navigationBar.barStyle = UIBarStyleBlack;
	
	// Make Home View Controller the root controller
	self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

/*------------------------------------------------------------------------------------*/

- (void)requestFailed:(NSString*)a_requestName error:(NSString*)a_error
{
	[[AppDelegate sharedDelegate] hideBusyView];
	
	[[JAMAlert sharedInstance] doOkAlert:[NSString stringWithFormat:@"Request %@ Failed", a_requestName]
								 message:a_error
									data:nil
								delegate:self];
}

/*------------------------------------------------------------------------------------*/

@end
