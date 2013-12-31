/*------------------------------------------------------------------------------------*/
//
//  FeaturedContentView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 12/14/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "FeaturedContentView.h"
#import "UIImageView+Mask.h"
#import "NSString+Convert.h"
#import "NSData+Save.h"
#import "JAMButton.h"
#import "JAMHitView.h"
#import "WebControllerHeaderView.h"
#import "HomeViewController.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Interface
#pragma mark -
/*------------------------------------------------------------------------------------*/

@interface FeaturedContentView() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
	IBOutlet UIScrollView * _scrollView;
	IBOutlet UIImageView * _imageView;
	IBOutlet UILabel * _dateMonthLabel;
	IBOutlet UILabel * _dateDayLabel;
	IBOutlet UILabel * _eventLabel;
	IBOutlet UILabel * _eventInfoLabel;
	IBOutlet UILabel * _venueLabel;
	IBOutlet UILabel * _venueInfoLabel;
	IBOutlet UILabel * _descriptionLabel;
	IBOutlet UILabel * _descriptionInfoLabel;
}
@end

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
#pragma mark -
/*------------------------------------------------------------------------------------*/

@implementation FeaturedContentView

/*------------------------------------------------------------------------------------*/
#pragma mark - Override Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	// Setup scroll views
	_scrollView.contentSize = self.frame.size;
	_scrollView.contentOffset = CGPointMake(0, 0);
	_scrollView.layer.shadowColor = [[UIColor blackColor] CGColor];
	_scrollView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
	_scrollView.layer.shadowOpacity = 0.75;
	
	// Determine if we need to update today's wwoz events
	NSCalendar * calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
	NSDateComponents * dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
	NSString * day = [NSString stringWithFormat:@"%i", dateComponents.day];
	NSString * month = globalShortMonthArray[dateComponents.month];
	BOOL updateEvents = NO;
	if ((![day isEqualToString:_dateDayLabel.text]) ||
		(![month isEqualToString:_dateMonthLabel.text]))
	{
		updateEvents = YES;
	}
	
	// Update current date
	_dateDayLabel.text = day;
	_dateMonthLabel.text = month;
	
	// Update todays events
	if (updateEvents)
	{
//FIX-ME		[[RequestManager sharedInstance] requestWWOZEvents:self.homeViewController date:nil];
	}
	else
	{
		[self displayFeaturedEvent];
	}
	
	// Call super
	[super awakeFromNib];
}

/*------------------------------------------------------------------------------------*/

- (void)displayFeaturedEvent
{
	// Currently this is randomly picking an event for today
	NSDictionary * data = [[AppDelegate sharedDelegate] wwozDateEventsDict];
	if ((data) &&
		([data count] > 1))
	{
		int index = (rand() % [[data allKeys] count]);
		id key = [[data allKeys] objectAtIndex:index];
		NSDictionary * eventDict = [data objectForKey:key];

		NSDictionary * venueDict = [[[AppDelegate sharedDelegate] wwozVenuesDict] objectForKey:[eventDict objectForKey:@"venue_nid"]];

		// Grab image, if there is one
		_imageView.image = [UIImage imageNamed:@"noImage.jpg"];
		if ([[RequestManager sharedInstance] requestImage:[venueDict objectForKey:@"lead_image"] forImageView:_imageView])
		{
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestImageFinishedNotification:) name:kRequestImageFinishedNotification object:nil];
		}
		[_imageView applyMaskWithImageAndSize:[UIImage imageNamed:@"image-mask.png"] size:_imageView.frame.size];
		
		CGFloat yOffset = 0;
		
		// Event
		_eventInfoLabel.numberOfLines = 0;
		_eventInfoLabel.text = nil;
		[_eventInfoLabel sizeToFit];
		_eventInfoLabel.text = [[eventDict objectForKey:@"title"] flattenHTML];
		[_eventInfoLabel sizeToFit];
		yOffset = (_eventInfoLabel.frame.origin.y + _eventInfoLabel.frame.size.height);
		
		// Venue Label
		CGRect frame = _venueLabel.frame;
		frame.origin.y = yOffset;
		_venueLabel.frame = frame;
		yOffset = (_venueLabel.frame.origin.y + _venueLabel.frame.size.height);
		
		// Venue Info Label
		frame = _venueInfoLabel.frame;
		frame.origin.y = yOffset;
		_venueInfoLabel.frame = frame;
		_venueInfoLabel.numberOfLines = 0;
		_venueInfoLabel.text = nil;
		[_venueInfoLabel sizeToFit];
		_venueInfoLabel.text = [[venueDict objectForKey:@"location_name"] flattenHTML];
		[_venueInfoLabel sizeToFit];
		yOffset = (_venueInfoLabel.frame.origin.y + _venueInfoLabel.frame.size.height);
		
		// Description Label
		frame = _descriptionLabel.frame;
		frame.origin.y = yOffset;
		_descriptionLabel.frame = frame;
		yOffset = (_descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height);
		
		// Description Info Label
		frame = _descriptionInfoLabel.frame;
		frame.origin.y = yOffset;
		_descriptionInfoLabel.frame = frame;
		NSString * text = [eventDict objectForKey:@"event_description_full"];
		if (isNSStringEmptyOrNil(text))
		{
			text = [eventDict objectForKey:@"event_description"];
		}
		if (isNSStringEmptyOrNil(text))
		{
			if (!isNSStringEmptyOrNil([venueDict objectForKey:@"body"]))
			{
				text = [venueDict objectForKey:@"body"];
			}
			else
			{
				NSDictionary * placesDict = [[AppDelegate sharedDelegate] placesDict];
				venueDict = [placesDict objectForKey:[venueDict objectForKey:@"venue_nid"]];
				if (venueDict)
				{
					text = [venueDict objectForKey:@"description"];
				}
				else
				{
					text = @"No description available";
				}
			}
		}
		_descriptionInfoLabel.numberOfLines = 0;
		_descriptionInfoLabel.text = nil;
		[_descriptionInfoLabel sizeToFit];
		_descriptionInfoLabel.text = [text flattenHTML];
		[_descriptionInfoLabel sizeToFit];
		
		// Update vertical scroll view content size
		CGSize size = _scrollView.contentSize;
		size.height = (_descriptionInfoLabel.frame.origin.y + _descriptionInfoLabel.frame.size.height);
		size.height += 50;
		_scrollView.contentSize = size;
	}
}

/*------------------------------------------------------------------------------------*/

- (IBAction)showHideDrawer:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kHomeShowHideDrawerNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

@end
