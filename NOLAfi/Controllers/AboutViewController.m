/*------------------------------------------------------------------------------------*/
//
//  AboutViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "AboutViewController.h"
#import "LoginViewController.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Interface
/*------------------------------------------------------------------------------------*/

@interface AboutViewController ()
{
	IBOutlet UIScrollView * _scrollView;
}
@end

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
/*------------------------------------------------------------------------------------*/

@implementation AboutViewController

/*------------------------------------------------------------------------------------*/
#pragma mark - Override Methods
/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Update scroll view content size
	CGSize size = _scrollView.frame.size;
	size.height = ((SCREEN_HEIGHT - (20 + 44)) * 2);
	_scrollView.contentSize = size;
}

/*------------------------------------------------------------------------------------*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------------------------------------------------------------------------*/

- (IBAction)closeButtonAction:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

@end
