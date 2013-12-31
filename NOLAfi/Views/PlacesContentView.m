/*------------------------------------------------------------------------------------*/
//
//  PlacesContentView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "PlacesContentView.h"
#import "PlaceDetailViewController.h"
#import "BusDetailViewController.h"
#import "EventsCategoriesTableView.h"
#import "EventsNeighborhoodsTableView.h"
#import "UIView+Custom.h"
#import "HomeViewController.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - NolaMapPoint Interface
/*------------------------------------------------------------------------------------*/

@interface NolaMapPoint : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;

@property (nonatomic, weak) NSDictionary * infoDict;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL bus;

@end

/*------------------------------------------------------------------------------------*/
#pragma mark - NolaMapPoint Implementation
/*------------------------------------------------------------------------------------*/

@implementation NolaMapPoint

/*------------------------------------------------------------------------------------*/

@end

/*------------------------------------------------------------------------------------*/
#pragma mark - PlacesContentView Private Interface
/*------------------------------------------------------------------------------------*/

@interface PlacesContentView()  <MKMapViewDelegate, CLLocationManagerDelegate>
{
	IBOutlet MKMapView * _mapView;
	
	IBOutlet UIView * _filterView;
	IBOutlet UIButton * _filterButton;
	IBOutlet UIButton * _categoriesButton;
	IBOutlet UIButton * _neighborhoodsButton;
	IBOutlet EventsCategoriesTableView * _categoriesTableView;
	IBOutlet EventsNeighborhoodsTableView * _neighborhoodsTableView;
	
	int _initialLocationUpdates;
	NSMutableArray * _mapAnnotations;
	
	BOOL _filterOverlayAnimating;
}

- (void)updateMapPoints:(NSString*)a_filter;

@end

/*------------------------------------------------------------------------------------*/
#pragma mark - PlacesContentView Implementation
/*------------------------------------------------------------------------------------*/

@implementation PlacesContentView

/*------------------------------------------------------------------------------------*/
#pragma mark - Override Methods
/*------------------------------------------------------------------------------------*/

- (void)dealloc
{
/* REMOVE-ME
	// Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestBussesFinishedNotification object:nil];
*/
}

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	// Initialize map view
	_mapView.delegate = self;
	_mapView.showsUserLocation = YES;
	_mapView.mapType = MKMapTypeStandard;
	_mapView.zoomEnabled = YES;

/* REMOVE-ME
	// Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestBussesFinishedNotification:) name:kRequestBussesFinishedNotification object:nil];
*/ 

	[AppDelegate animateMapToLocation:_mapView location:((AppDelegate*)[AppDelegate sharedDelegate]).currLocation.coordinate];
	
	[self updateMapPoints:nil];
	
/* FIX-ME
	// Request places if we haven't done so already
	if (![[AppDelegate sharedDelegate] placesDict])
	{
//FIX-ME		[[RequestManager sharedInstance] requestPlaces:self.homeViewController];
	}
*/

	// Call super
	[super awakeFromNib];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - IBAction Methods
/*------------------------------------------------------------------------------------*/

- (IBAction)showHideDrawer:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kHomeShowHideDrawerNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)locationButtonAction:(id)sender
{
	[AppDelegate animateMapToLocation:_mapView location:((AppDelegate*)[AppDelegate sharedDelegate]).currLocation.coordinate];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)filterButtonAction:(id)sender
{
	if (_filterOverlayAnimating)
	{
		return;
	}
	
	_filterButton.selected = !_filterButton.selected;
	
	if (_filterButton.selected)
	{
		CGRect frame = _filterView.frame;
		frame.origin.y = -frame.size.height;
		_filterView.frame = frame;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:kDefaultAnimationDuration
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^{
								 CGRect frame = _filterView.frame;
								 frame.origin.y = 45;
								 _filterView.frame = frame;
								 _filterView.hidden = NO;
								 _filterOverlayAnimating = YES;
							 }
							 completion:^(BOOL finished){
								 _filterOverlayAnimating = NO;
							 }
			 ];
		});
	}
	else
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:kDefaultAnimationDuration
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseOut
							 animations:^{
								 CGRect frame = _filterView.frame;
								 frame.origin.y -= frame.size.height;
								 _filterView.frame = frame;
								 _filterOverlayAnimating = YES;
							 }
							 completion:^(BOOL finished){
								 _filterView.hidden = YES;
								 _filterOverlayAnimating = NO;
							 }
			 ];
		});
	}
}

/*------------------------------------------------------------------------------------*/

- (IBAction)categoriesButtonAction:(id)sender
{
	_categoriesButton.selected = YES;
	_categoriesTableView.hidden = NO;
	[_categoriesTableView reloadData];
	
	_neighborhoodsButton.selected = NO;
	_neighborhoodsTableView.hidden = YES;
}

/*------------------------------------------------------------------------------------*/

- (IBAction)neighborhoodsButtonAction:(id)sender
{
	_neighborhoodsButton.selected = YES;
	_neighborhoodsTableView.hidden = NO;
	[_neighborhoodsTableView reloadData];
	
	_categoriesButton.selected = NO;
	_categoriesTableView.hidden = YES;
}

/*------------------------------------------------------------------------------------*/

- (void)updateMapPoints:(NSString*)a_filter
{
	[_mapView removeAnnotations:_mapView.annotations];

	// Add places map points
	if (![a_filter isEqualToString:@"bus"])
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSArray * placesArray = ((AppDelegate*)[AppDelegate sharedDelegate]).placesArray;
			for (NSDictionary * locationDict in placesArray)
			{
				if (locationDict)
				{
					NSString * lat = [locationDict objectForKey:@"lat"];
					NSString * lng = [locationDict objectForKey:@"lng"];
					
					if ((!isNSStringEmptyOrNil(lat)) &&
						(!isNSStringEmptyOrNil(lng)))
					{
						NSString * tags = [locationDict objectForKey:@"tags"];
						if (!(a_filter) ||
							((!isNSStringEmptyOrNil(tags)) &&
							 ([tags rangeOfString:a_filter options:NSCaseInsensitiveSearch].length)))
						{
	//						debug NSLog(@">> tags = %@ <<", [locationDict objectForKey:@"tags"]);
							
							NolaMapPoint * mapPoint = [[NolaMapPoint alloc] init];
							mapPoint.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
							mapPoint.title = [locationDict objectForKey:@"name"];
							mapPoint.subtitle = [locationDict objectForKey:@"address"];
							mapPoint.infoDict = locationDict;
							dispatch_async(dispatch_get_main_queue(), ^{
								[_mapView addAnnotation:mapPoint];
							});
						}
					}
				}
			}
		});
	}
	else
	{
		// Add busses map points
		[[AppDelegate sharedDelegate] requestBusses];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)requestBussesFinishedNotification:(NSNotification*)a_notification
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSArray * allKeys = [((AppDelegate*)[AppDelegate sharedDelegate]).bussesDict allKeys];
		for (id key in allKeys)
		{
			NSDictionary * busDict = [((AppDelegate*)[AppDelegate sharedDelegate]).bussesDict objectForKey:key];
			NSString * lat = [busDict objectForKey:@"lat"];
			NSString * lng = [busDict objectForKey:@"lng"];
			
			if ((!isNSStringEmptyOrNil(lat)) &&
				(!isNSStringEmptyOrNil(lng)))
			{
				NolaMapPoint * mapPoint = [[NolaMapPoint alloc] init];
				mapPoint.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
				mapPoint.title = [busDict objectForKey:@"name"];
				mapPoint.infoDict = busDict;
				mapPoint.bus = YES;
				dispatch_async(dispatch_get_main_queue(), ^{
					[_mapView addAnnotation:mapPoint];
				});
			}
		}
	});
}

/*------------------------------------------------------------------------------------*/
#pragma mark - MKMapViewDelegate Methods
/*------------------------------------------------------------------------------------*/

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
{
	static NSString * reuseIdentifier = @"CustomAnnotationView";
	
    if ([[annotation title] isEqualToString:@"Current Location"])
	{
        return nil;
    }

	MKAnnotationView * customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	customAnnotationView.image = [UIImage imageNamed:@"map-locations.png"];

	// Add detail button
	UIButton * infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[infoButton addTarget:self
				   action:@selector(presentMapAnnotationDetail:)
		 forControlEvents:UIControlEventTouchUpInside];
	infoButton.customNSDictionary = [(NolaMapPoint*)annotation infoDict];
	customAnnotationView.rightCalloutAccessoryView = infoButton;
	customAnnotationView.canShowCallout = YES;

	if (([annotation isKindOfClass:[NolaMapPoint class]]) &&
		(((NolaMapPoint*)annotation).bus))
	{
		customAnnotationView.image = [UIImage imageNamed:@"bus-icon.png"];
		infoButton.customIdentifierNSString = @"Bus";
	}
	
	return customAnnotationView;
}

/*------------------------------------------------------------------------------------*/

- (void)presentMapAnnotationDetail:(UIButton*)a_button
{
	UIViewController * controller = nil;
	if ([a_button.customIdentifierNSString isEqualToString:@"Bus"])
	{
		BusDetailViewController * busController = [[BusDetailViewController alloc] init];
		controller = busController;
	}
	else
	{
		PlaceDetailViewController * placeController = [[PlaceDetailViewController alloc] init];
		placeController.placeDict = [a_button customNSDictionary];
		controller = placeController;
	}
	[self.homeViewController.navigationController pushViewController:controller animated:YES];
}

/*------------------------------------------------------------------------------------*/

@end

