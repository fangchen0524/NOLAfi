/*------------------------------------------------------------------------------------*/
//
//  EventDetailViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "EventDetailViewController.h"
#import "NSData+Save.h"
#import "NSString+Convert.h"
#import "JAMURLRequest.h"
#import "AppDelegate.h"
#import "RequestManager.h"

/*------------------------------------------------------------------------------------*/

@interface EventDetailViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) IBOutlet UIImageView * imageView;
@property (nonatomic, strong) IBOutlet UILabel * eventLabel;
@property (nonatomic, strong) IBOutlet UILabel * eventInfoLabel;
@property (nonatomic, strong) IBOutlet UILabel * venueLabel;
@property (nonatomic, strong) IBOutlet UILabel * venueInfoLabel;
@property (nonatomic, strong) IBOutlet UILabel * descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel * descriptionInfoLabel;

@end

/*------------------------------------------------------------------------------------*/

@implementation EventDetailViewController

/*------------------------------------------------------------------------------------*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self)
	{
        // Custom initialization
    }
	
    return self;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSDictionary * venueDict = [[[AppDelegate sharedDelegate] wwozVenuesDict] objectForKey:[self.eventDict objectForKey:@"venue_nid"]];
	
	// Request image, if there is one
	RequestResponseBlock successBlock = ^(NSDictionary * a_resultDict){
		self.imageView.image = [[a_resultDict objectForKey:@"success"] objectForKey:@"image"];
	};
	RequestResponseBlock failureBlock = ^(NSDictionary * a_resultDict){
		// Do nothing
	};
	if (![[AppDelegate sharedDelegate] findImageUrlPathWithEventDict:self.eventDict venueDict:venueDict successBlock:successBlock failureBlock:failureBlock])
	{
		self.imageView.image = [UIImage imageNamed:@"welcome.png"];
	}

	self.imageView.layer.cornerRadius = 8;
	self.imageView.layer.masksToBounds = YES;

	CGFloat yOffset = 0;

	// Event
	self.eventInfoLabel.numberOfLines = 0;
	self.eventInfoLabel.text = [[self.eventDict objectForKey:@"title"] flattenHTML];
	[self.eventInfoLabel sizeToFit];
	yOffset = (self.eventInfoLabel.frame.origin.y + self.eventInfoLabel.frame.size.height);
	
	// Venue Label
	CGRect frame = self.venueLabel.frame;
	frame.origin.y = yOffset;
	self.venueLabel.frame = frame;
	yOffset = (self.venueLabel.frame.origin.y + self.venueLabel.frame.size.height);
	
	// Venue Info Label
	frame = self.venueInfoLabel.frame;
	frame.origin.y = yOffset;
	self.venueInfoLabel.frame = frame;
	self.venueInfoLabel.numberOfLines = 0;
	self.venueInfoLabel.text = [[venueDict objectForKey:@"location_name"] flattenHTML];
	[self.venueInfoLabel sizeToFit];
	yOffset = (self.venueInfoLabel.frame.origin.y + self.venueInfoLabel.frame.size.height);
	
	// Description Label
	frame = self.descriptionLabel.frame;
	frame.origin.y = yOffset;
	self.descriptionLabel.frame = frame;
	yOffset = (self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height);
	
	// Description Info Label
	frame = self.descriptionInfoLabel.frame;
	frame.origin.y = yOffset;
	self.descriptionInfoLabel.frame = frame;
	self.descriptionInfoLabel.text = [self.eventDict objectForKey:@"event_description_full"];
	if (isNSStringEmptyOrNil(self.descriptionInfoLabel.text))
	{
		self.descriptionInfoLabel.text = [self.eventDict objectForKey:@"event_description"];
	}
	if (isNSStringEmptyOrNil(self.descriptionInfoLabel.text))
	{
		if (!isNSStringEmptyOrNil([venueDict objectForKey:@"body"]))
		{
			self.descriptionInfoLabel.text = [venueDict objectForKey:@"body"];
		}
		else
		{
/* FIX-ME
			id placesDict = [[AppDelegate sharedDelegate] placesArray];
			venueDict = [placesDict objectForKey:[venueDict objectForKey:@"venue_nid"]];
			if (venueDict)
			{
				self.descriptionInfoLabel.text = [venueDict objectForKey:@"description"];
			}
			else
			{
				self.descriptionInfoLabel.text = @"No description available";
			}
*/ 
		}
	}
	self.descriptionInfoLabel.numberOfLines = 0;
	self.descriptionInfoLabel.text = [self.descriptionInfoLabel.text flattenHTML];
	[self.descriptionInfoLabel sizeToFit];

	// Update scroll view content size
	CGSize size = self.scrollView.contentSize;
	size.height = (self.descriptionInfoLabel.frame.origin.y + self.descriptionInfoLabel.frame.size.height);
	size.height += 50;
	self.scrollView.contentSize = size;
}

/*------------------------------------------------------------------------------------*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------------------------------------------------------------------------*/

- (IBAction)backButtonAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*------------------------------------------------------------------------------------*/

@end
