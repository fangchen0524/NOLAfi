/*------------------------------------------------------------------------------------*/
//
//  TestImageViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/8/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestImageViewController.h"

/*------------------------------------------------------------------------------------*/

@interface TestImageViewController ()

@end

/*------------------------------------------------------------------------------------*/

@implementation TestImageViewController

/*------------------------------------------------------------------------------------*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self)
	{
		// Force load
		[self view];
		
		self.imageView.layer.cornerRadius = 8;
		self.imageView.layer.masksToBounds = YES;
    }
	
    return self;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*------------------------------------------------------------------------------------*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------------------------------------------------------------------------*/

- (void)requestImage:(NSString*)a_imageUrlPath
{
	__block RequestResponseBlock successBlock = ^(NSDictionary * a_resultDict){
		self.imageView.image = [[a_resultDict objectForKey:@"success"] objectForKey:@"image"];
		
		[[AppDelegate sharedDelegate] hideBusyView];
	};
	
	__block RequestResponseBlock failureBlock = ^(NSDictionary * a_resultDict){
		[[AppDelegate sharedDelegate] hideBusyView];
	};
	
	[[AppDelegate sharedDelegate] showBusyView];
	
	[[RequestManager sharedInstance] requestImage:successBlock failureBlock:failureBlock imageUrlPath:a_imageUrlPath];
}

/*------------------------------------------------------------------------------------*/

@end
