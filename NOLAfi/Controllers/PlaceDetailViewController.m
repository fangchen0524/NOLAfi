/*------------------------------------------------------------------------------------*/
//
//  PlaceDetailViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "PlaceDetailViewController.h"
#import "NSData+Save.h"
#import "JAMURLRequest.h"
#import "JAMAppDelegate.h"
#import "RequestManager.h"

/*------------------------------------------------------------------------------------*/

@interface PlaceDetailViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UILabel * infoLabel;
@property (nonatomic, strong) IBOutlet UIImageView * imageView;

@end

/*------------------------------------------------------------------------------------*/

@implementation PlaceDetailViewController

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
	
	self.scrollView.contentSize = self.view.frame.size;
	
	self.titleLabel.text = [self.placeDict objectForKey:@"title"];
	self.infoLabel.text = [self.placeDict objectForKey:@"event_description_full"];

	self.imageView.layer.cornerRadius = 8;
	self.imageView.layer.masksToBounds = YES;
	
	RequestResponseBlock successBlock = ^(NSDictionary * a_resultDict){
		self.imageView.image = [[a_resultDict objectForKey:@"success"] objectForKey:@"image"];
	};
	
	RequestResponseBlock failureBlock = ^(NSDictionary * a_resultDict){
		// Do nothing
		int j = 1;
		j = j;
	};
	[[RequestManager sharedInstance] requestImage:successBlock failureBlock:failureBlock imageUrlPath:[self.placeDict objectForKey:@"image"]];
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
