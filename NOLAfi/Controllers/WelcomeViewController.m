/*------------------------------------------------------------------------------------*/
//
//  WelcomeViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "WelcomeViewController.h"
#import "AccountViewController.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Defines
/*------------------------------------------------------------------------------------*/

#if DEBUG
	#define TEST_LOGIN	0
#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Interface
/*------------------------------------------------------------------------------------*/

@interface WelcomeViewController ()
{
	
}
@end

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
/*------------------------------------------------------------------------------------*/

@implementation WelcomeViewController

/*------------------------------------------------------------------------------------*/
#pragma mark - Override Methods
/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Start backend connection
	[[AppDelegate sharedDelegate] connectToBackend];
}

/*------------------------------------------------------------------------------------*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------------------------------------------------------------------------*/

@end
