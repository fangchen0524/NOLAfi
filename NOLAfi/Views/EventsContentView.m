/*------------------------------------------------------------------------------------*/
//
//  EventsContentView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/19/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "EventsContentView.h"
#import "UIView+Custom.h"
#import "EventTableViewCell.h"
#import "EventsCategoriesTableView.h"
#import "ConciergeFilterTableView.h"
#import "ConciergeQuestionsTableView.h"
#import "ConciergeContentView.h"
#import "NSString+Convert.h"
#import "HomeViewController.h"
#import "JAMBitmap.h"
#import "UIButton+Custom.h"

/*------------------------------------------------------------------------------------*/

@interface EventsContentView() <UIGestureRecognizerDelegate>
{
	IBOutlet UILabel * _holderDateLabel;
	IBOutlet UITableView * _tableView;
	IBOutlet UIView * _weekPopupView;
	IBOutlet UIView * _filterView;
	IBOutlet UIButton * _filterButton;
	IBOutlet UIButton * _categoriesButton;
	IBOutlet UIButton * _conciergeButton;
	IBOutlet UIButton * _todayButton;
	IBOutlet UIButton * _featuredButton;
	IBOutlet UIButton * _weekdayButton1;
	IBOutlet UIButton * _weekdayButton2;
	IBOutlet UIButton * _weekdayButton3;
	IBOutlet UIButton * _weekdayButton4;
	IBOutlet UIButton * _weekdayButton5;
	IBOutlet UIButton * _weekdayButton6;
	IBOutlet UIButton * _weekdayButton7;
	IBOutlet EventsCategoriesTableView * _categoriesTableView;
	IBOutlet ConciergeFilterTableView * _conciergeFilterTableView;

	UILabel * _holderWeekdayViewLabel;
	NSMutableArray * _eventDataArray;
	NSMutableArray * _dayButtons;
	UIImage * _defaultImage;
	UIButton * _lastSelectWeekPopupButton;

	BOOL _filterOverlayAnimating;
	BOOL _weekPopupViewAnimating;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation EventsContentView

- (void)dealloc
{
	// Remove observers
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestWWOZEventsNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	// Add observers
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestWWOZEventsNotification:) name:kRequestWWOZEventsNotification object:nil];
	
	// Display new date
	NSUInteger unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit);
	NSDate * date = (((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate ? ((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate : [NSDate date]);
	((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate = date;
	NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
	_holderDateLabel.text = [NSString stringWithFormat:@"%@", globalShortDayOfWeekArray[dateComponents.weekday]];
	
	// Setup events
	[self setupEventDataArray];
	[self setupPopupDayButtons];
	
	// Setup views & buttons
	_todayButton.customInitialCGRect = [NSValue valueWithCGRect:_todayButton.frame];
	_todayButton.layer.shadowColor = [[UIColor blackColor] CGColor];
	_todayButton.layer.shadowOffset = CGSizeMake(2, 2);
	_todayButton.layer.shadowOpacity = 0.75;
	_weekPopupView.customInitialCGRect = [NSValue valueWithCGRect:_weekPopupView.frame];
	CGRect frame = _todayButton.frame;
	_weekPopupView.frame = frame;
	_featuredButton.layer.shadowColor = [[UIColor blackColor] CGColor];
	_featuredButton.layer.shadowOffset = CGSizeMake(-2, 2);
	_featuredButton.layer.shadowOpacity = 0.75;
	
	// Call super
	[super awakeFromNib];
}

/*------------------------------------------------------------------------------------*/

- (void)requestWWOZEventsNotification:(NSNotification*)a_notification
{
	// Display new date
	NSUInteger unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit);
	NSDate * date = (((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate ? ((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate : [NSDate date]);
	((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate = date;
	NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
	_holderDateLabel.text = [NSString stringWithFormat:@"%@ %i, %i (%@)",
							 globalMonthArray[dateComponents.month],
							 dateComponents.day,
							 dateComponents.year,
							 globalShortDayOfWeekArray[dateComponents.weekday]];
	
	// Setup eventDataArray
	[self setupEventDataArray];
	[self setupPopupDayButtons];

	// Reload table with new event data
	[_tableView reloadData];
	
	// Scroll to top
	CGPoint topOffset = CGPointMake(0, -_tableView.contentInset.top);
	[_tableView setContentOffset:topOffset animated:YES];
}

/*------------------------------------------------------------------------------------*/

- (void)setupEventDataArray
{
	_eventDataArray = [[NSMutableArray alloc] initWithCapacity:[[[AppDelegate sharedDelegate] wwozDateEventsDict] count]];

	if (!_defaultImage)
	{
		_defaultImage = [UIImage imageNamed:@"welcome.png"];
	}

	NSArray * allKeys = [[[AppDelegate sharedDelegate] wwozDateEventsDict] allKeys];
	for (NSInteger index = 0; index < [[[AppDelegate sharedDelegate] wwozDateEventsDict] count]; index++)
	{
		__block NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
		
		NSDictionary * eventDict = [[[AppDelegate sharedDelegate] wwozDateEventsDict] objectForKey:[allKeys objectAtIndex:index]];
		[dataDict setObject:eventDict forKey:@"eventDict"];
		[dataDict setObject:[[eventDict objectForKey:@"title"] flattenHTML] forKey:@"title"];
		NSString * description = [[eventDict objectForKey:@"event_description_full"] flattenHTML];
		if (isNSStringEmptyOrNil(description))
		{
			description = [[eventDict objectForKey:@"event_description"] flattenHTML];
		}
		[dataDict setObject:description forKey:@"info"];
		
		NSDictionary * venueDict = [[[AppDelegate sharedDelegate] wwozVenuesDict] objectForKey:[eventDict objectForKey:@"venue_nid"]];
		[dataDict setObject:[[NSString stringWithFormat:@"%@\n%@",
							  [eventDict objectForKey:@"venue_title"],
							  [venueDict objectForKey:@"street"]] flattenHTML] forKey:@"venue"];
		
		NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[eventDict objectForKey:@"event_date_from"] doubleValue]];
		NSCalendar * calendar = [NSCalendar currentCalendar];
		NSUInteger unitFlags = (NSHourCalendarUnit);
		NSDateComponents * dateComponents = [calendar components:unitFlags fromDate:date];
		NSInteger hour = [dateComponents hour];
		NSString * time = [NSString stringWithFormat:@"%ia", hour];
		if (hour > 12)
		{
			time = [NSString stringWithFormat:@"%ip", (hour - 12)];
		}
		[dataDict setObject:time forKey:@"time"];
		
		[_eventDataArray insertObject:dataDict atIndex:index];
		
		// Request image
		__block RequestResponseBlock successBlock = ^(NSDictionary * a_resultDict){
			[dataDict setObject:[[a_resultDict objectForKey:@"success"] objectForKey:@"image"] forKey:@"picture"];
		};
		__block RequestResponseBlock failureBlock = ^(NSDictionary * a_resultDict){
			// Do nothing
		};
		BOOL hasImage = [[AppDelegate sharedDelegate] findImageUrlPathWithEventDict:eventDict venueDict:venueDict successBlock:successBlock failureBlock:failureBlock];
		[dataDict setObject:[NSNumber numberWithBool:hasImage] forKey:@"hasImage"];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)setupPopupDayButtons
{
	_dayButtons = [NSMutableArray arrayWithObjects:
					_weekdayButton1,
					_weekdayButton2,
					_weekdayButton3,
					_weekdayButton4,
					_weekdayButton5,
					_weekdayButton6,
					_weekdayButton7,
					nil];
	
	NSDate * today = [NSDate date];
	NSUInteger unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit);
	
	CGFloat timeInterval = 0;
	for (int i = 1; i <= 7; i++)
	{
		NSDate * newDate = [today dateByAddingTimeInterval:timeInterval];
		NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:newDate];

		UIButton * button = (UIButton*)[_dayButtons objectAtIndex:(i - 1)];
		NSString * title = [NSString stringWithFormat:@"  %@ - %@ %i",
							[globalShortDayOfWeekArray[dateComponents.weekday] uppercaseString],
							[globalShortMonthArray[dateComponents.month] uppercaseString],
							dateComponents.day];
		if (i == 1)
		{
			title = [NSString stringWithFormat:@"  TODAY - %@ %i",
					 [globalShortMonthArray[dateComponents.month] uppercaseString],
					 dateComponents.day];
			if (!_lastSelectWeekPopupButton)
			{
				button.highlighted = YES;
				_lastSelectWeekPopupButton = button;
			}
		}
		if (button == _lastSelectWeekPopupButton)
		{
			button.highlighted = YES;
		}
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitle:title forState:UIControlStateSelected];
		[button setTitle:title forState:UIControlStateHighlighted];
		[button setCustomNSDictionary:[NSDictionary dictionaryWithObject:newDate forKey:@"date"]];
		[button setAlpha:0.0];
		
		timeInterval += kSecsPerDay;
	}
	
	[self updateWeekPopupButtonsWithAlpha:0.0 userInteractionEnabled:NO];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)showHideDrawer:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kHomeShowHideDrawerNotification object:self userInfo:nil];
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
	
	_conciergeButton.selected = NO;
	_conciergeFilterTableView.hidden = YES;
}

/*------------------------------------------------------------------------------------*/

- (IBAction)conciergeButtonAction:(id)sender
{
	[_conciergeFilterTableView.conciergeFilterArray removeAllObjects];
	
	for (NSInteger questionIndex = 0; questionIndex < kNumQuestions; questionIndex++)
	{
		NSString * key = [ConciergeQuestionsTableView questionsKeyForIndex:questionIndex];
		if (key)
		{
			NSArray * answersArray = [[NSUserDefaults standardUserDefaults] objectForKey:key];
			if (answersArray)
			{
				for (NSInteger index = 0; index < [ConciergeQuestionsTableView numberOfQuestionsForIndex:questionIndex]; index++)
				{
					if ([[answersArray objectAtIndex:index] boolValue])
					{
						NSString * answer = [ConciergeQuestionsTableView answerForQuestion:questionIndex subIndex:index];
						NSString * keyword = [ConciergeQuestionsTableView questionKeywordForIndex:questionIndex];
						[_conciergeFilterTableView.conciergeFilterArray addObject:[NSString stringWithFormat:@"[%@] %@", [keyword capitalizedString], answer]];
					}
				}
			}
		}
	}
	
	_conciergeButton.selected = YES;
	_conciergeFilterTableView.hidden = NO;
	[_conciergeFilterTableView reloadData];
	
	_categoriesButton.selected = NO;
	_categoriesTableView.hidden = YES;
}

/*------------------------------------------------------------------------------------*/

- (IBAction)todayButtonAction:(id)sender
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:kDefaultAnimationDuration
						 animations:^{
							 if (CGRectEqualToRect(_weekPopupView.frame, _todayButton.frame))
							 {
								 _weekPopupView.frame = [[_weekPopupView customInitialCGRect] CGRectValue];
								 _todayButton.alpha = 0.0;
								 [self updateWeekPopupButtonsWithAlpha:1.0 userInteractionEnabled:YES];
							 }
							 else
							 {
								 _todayButton.alpha = 1.0;
								 _weekPopupView.frame = _todayButton.frame;
								 [self updateWeekPopupButtonsWithAlpha:0.0 userInteractionEnabled:NO];
							 }
							 _weekPopupViewAnimating = YES;
						 }
						 completion:^(BOOL finished){
							 _weekPopupViewAnimating = NO;
							 _weekPopupView.layer.shadowColor = [[UIColor blackColor] CGColor];
							 _weekPopupView.layer.shadowOffset = CGSizeMake(2, 2);
							 _weekPopupView.layer.shadowOpacity = 0.75;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/

- (void)updateWeekPopupButtonsWithAlpha:(CGFloat)a_alpha userInteractionEnabled:(BOOL)a_userInteractionEnabled
{
	_weekPopupView.userInteractionEnabled = a_userInteractionEnabled;
	
	for (UIButton * button in _dayButtons)
	{
		button.alpha = a_alpha;
		button.userInteractionEnabled = a_userInteractionEnabled;
	}
}

/*------------------------------------------------------------------------------------*/

- (IBAction)weekdayButtonAction:(UIButton*)a_sender
{
	if (_weekPopupViewAnimating)
	{
		return;
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:kDefaultAnimationDuration
						 animations:^{
							 _todayButton.frame = [[_todayButton customInitialCGRect] CGRectValue];
							 _todayButton.alpha = 1.0;
							 _weekPopupView.frame = _todayButton.frame;
							 [self updateWeekPopupButtonsWithAlpha:0.0 userInteractionEnabled:NO];
							 _weekPopupViewAnimating = YES;
						 }
						 completion:^(BOOL finished){
							 _weekPopupViewAnimating = NO;
							 _weekPopupView.layer.shadowColor = [[UIColor blackColor] CGColor];
							 _weekPopupView.layer.shadowOffset = CGSizeMake(2, 2);
							 _weekPopupView.layer.shadowOpacity = 0.75;
						 }
		 ];
	});

	// Request events for new date
	NSDate * newDate = [[a_sender customNSDictionary] objectForKey:@"date"];
	((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate = newDate;
	NSUInteger unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit);
	NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:newDate];
	NSString * dateString = [NSString stringWithFormat:@"%i-%02i-%02i", dateComponents.year, dateComponents.month, dateComponents.day];
	[[AppDelegate sharedDelegate] requestWWOZEvents:dateString];

	// Update selection states
	if (_lastSelectWeekPopupButton)
	{
		_lastSelectWeekPopupButton.highlighted = NO;
	}
	_lastSelectWeekPopupButton = a_sender;
	a_sender.highlighted = YES;
}

/*------------------------------------------------------------------------------------*/
// UITableView Delegate
/*------------------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[AppDelegate sharedDelegate] wwozDateEventsDict] count];
}

/*------------------------------------------------------------------------------------*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary * dataDict = [_eventDataArray objectAtIndex:indexPath.row];
	if (![[dataDict objectForKey:@"hasImage"] boolValue])
	{
		return 163;
	}
	
	return 378;
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * sCellIdentifier = @"EventCellIdentifier";
	static NSString * sCellNoImageIdentifier = @"EventNoImageCellIdentifier";

	NSDictionary * dataDict = [_eventDataArray objectAtIndex:indexPath.row];
	
	EventTableViewCell * cell = nil;
	NSString * cellNibName = nil;
	if (![[dataDict objectForKey:@"hasImage"] boolValue])
	{
		cellNibName = @"EventNoImageTableViewCell";
		cell = (EventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:sCellNoImageIdentifier];
	}
	else
	{
		cellNibName = @"EventTableViewCell";
		cell = (EventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
	}
	
	if (!cell)
	{
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:cellNibName owner:nil options:nil];
		cell = (EventTableViewCell*)[nib objectAtIndex:0];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.parentViewController = self.homeViewController;
	if ([[dataDict objectForKey:@"hasImage"] boolValue])
	{
		cell.pictureImageView.layer.cornerRadius = 8;
		cell.pictureImageView.layer.masksToBounds = YES;
	}
	cell.eventDict = [dataDict objectForKey:@"eventDict"];
	cell.titleLabel.text = [dataDict objectForKey:@"title"];
	cell.infoLabel.text = [dataDict objectForKey:@"info"];
	NSArray * components = [[dataDict objectForKey:@"venue"] componentsSeparatedByString:@"\n"];
	cell.venueTitleLabel.text = [components objectAtIndex:0];
	cell.venueAddressLabel.text = [components objectAtIndex:1];
	cell.dateLabel.text = 
	cell.timeLabel.text = [dataDict objectForKey:@"time"];
	if ([[dataDict objectForKey:@"hasImage"] boolValue])
	{
		cell.pictureImageView.image = [dataDict objectForKey:@"picture"];
		if (!cell.pictureImageView.image)
		{
			cell.pictureImageView.image = _defaultImage;
		}
	}
	
	NSUInteger unitFlags = (NSMonthCalendarUnit | NSDayCalendarUnit);
	NSDate * date = ((AppDelegate*)[AppDelegate sharedDelegate]).selectedDate;
	NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
	cell.dateLabel.text = [NSString stringWithFormat:@"%@ %i",
						   [globalShortMonthArray[dateComponents.month] uppercaseString],
						   dateComponents.day];

	return cell;
}

/*------------------------------------------------------------------------------------*/

@end
