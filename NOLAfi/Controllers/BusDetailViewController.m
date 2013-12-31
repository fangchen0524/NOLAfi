/*------------------------------------------------------------------------------------*/
//
//  BusDetailViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "BusDetailViewController.h"

/*------------------------------------------------------------------------------------*/

@interface BusDetailViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UILabel * infoLabel;

@end

/*------------------------------------------------------------------------------------*/

@implementation BusDetailViewController

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
