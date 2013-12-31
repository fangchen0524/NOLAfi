/*------------------------------------------------------------------------------------*/
//
//  RegisterChooseViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "RegisterChooseViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "RequestManager.h"
#import "NSString+MD5.h"

/*------------------------------------------------------------------------------------*/

@interface RegisterChooseViewController ()

@end

/*------------------------------------------------------------------------------------*/

@implementation RegisterChooseViewController

/*------------------------------------------------------------------------------------*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"Register Choose";
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[[AppDelegate sharedDelegate] hideBusyView];
	
	// Add facebook login observers
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidLoginNotificationCallback:) name:kFacebookLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidNotLoginNotificationCallback:) name:kFacebookDidNotLoginNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFacebookLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFacebookDidNotLoginNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

/*------------------------------------------------------------------------------------*/

- (IBAction)registerButtonAction:(id)sender
{
	// Present register screen
	RegisterViewController * controller = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	[self presentViewController:controller animated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)registerFacebookButtonAction:(id)sender
{
	// Authenticate with facebook
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Authenticating..."];
	[[[AppDelegate sharedDelegate] jamFacebook] authenticate];
}

/*------------------------------------------------------------------------------------*/
// Facebook Notifications
/*------------------------------------------------------------------------------------*/

- (void)fbDidLoginNotificationCallback:(NSNotification*)a_notification
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary * facebookDict = [defaults objectForKey:kFacebookUserDataKey];
	NSString * username = [[facebookDict objectForKey:@"uid"] stringValue];
	NSString * email = [facebookDict objectForKey:@"email"];
	NSString * password = [[NSString stringWithFormat:@"@%@@", username] md5EncodedString];
	
	[[AppDelegate sharedDelegate] requestRegistration:[NSDictionary dictionaryWithObjectsAndKeys:
													   username, @"username",
													   password, @"password",
													   email, @"email",
													   nil]];
}

/*------------------------------------------------------------------------------------*/

- (void)fbDidNotLoginNotificationCallback:(NSNotification*)a_notification
{
	[[JAMAlert sharedInstance] doOkAlert:@"Facebook"
								 message:@"Login failed"
									data:nil
								delegate:nil];
}

/*------------------------------------------------------------------------------------*/

@end
