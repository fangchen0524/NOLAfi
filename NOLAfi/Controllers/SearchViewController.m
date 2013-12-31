/*------------------------------------------------------------------------------------*/
//
//  SearchViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "SearchViewController.h"

/*------------------------------------------------------------------------------------*/

@interface SearchViewController ()

@end

/*------------------------------------------------------------------------------------*/

@implementation SearchViewController

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
