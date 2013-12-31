/*------------------------------------------------------------------------------------*/
//
//  LoginViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "RegisterChooseViewController.h"
#import "RequestManager.h"

/*------------------------------------------------------------------------------------*/

@interface LoginViewController ()
{
	IBOutlet UITextField * _usernameTextField;
	IBOutlet UITextField * _passwordTextField;
	IBOutlet UITextView * _wwozTextView;
	IBOutlet UIButton * _loginButton;
	IBOutlet UIButton * _retryButton;
	IBOutlet UIButton * _facebookLoginButton;
	
	NSTimer * _facebookTimeoutTimer;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation LoginViewController

/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Login";
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidUnload
{
    [super viewDidUnload];
}

/*------------------------------------------------------------------------------------*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Connecting..."];
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	if ((self.loginType == kLoginTypeFacebook) ||
		([defaults objectForKey:kFacebookAuthenticationKey]))
	{
		if ([defaults objectForKey:kFacebookAuthenticationKey])
		{
			debug NSLog(@">> Attempt login via Facebook. <<");
			
			// Add facebook login observers
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidLoginNotificationCallback:) name:kFacebookLoginNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidNotLoginNotificationCallback:) name:kFacebookDidNotLoginNotification object:nil];
			
			// Wait a second before authenticating
			[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(authenticateFacebookTimerCallback:) userInfo:nil repeats:NO];
		}
		else
		{
			// Facebook needs to be authenticated
			[self presentRegisterController];
		}
	}
	else
	{
/*
		// Request login
		[[RequestManager sharedInstance]
		 requestLogin:^(NSDictionary * a_resultDict){
			 NSString * error = [a_resultDict objectForKey:@"error"];
			 if (!isNSStringEmptyOrNil(error))
			 {
				 [self requestStatusFailed:error];
				 return NO;
			 }
			 return YES;
		 }
		 failureBlock:^(NSDictionary *a_resultDict){
			 NSString * error = [a_resultDict objectForKey:@"failure"];
			 if (isNSStringEmptyOrNil(error))
			 {
				 error = @"Unknown error type";
			 }
			 [self requestStatusFailed:error];
		 }
		 params:a_paramsDict
		 ];
*/ 
	}
}

/*------------------------------------------------------------------------------------*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

/*------------------------------------------------------------------------------------*/

- (void)authenticateFacebookTimerCallback:(NSTimer*)a_timer
{
	// Authenticate with facebook
	BOOL authenticated = NO;
	[[AppDelegate sharedDelegate] showBusyViewWithText:@"Authenticating..."];
	if (([[[AppDelegate sharedDelegate] jamFacebook] authenticate]) ||
		([[AppDelegate sharedDelegate] attemptingLogin]))
	{
		authenticated = YES;
	}
	[self loginDisplayState:authenticated];
	
	// Add timeout timer for facebook authentication
	_facebookTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(facebookTimeoutTimerCallback:) userInfo:nil repeats:NO];
}

/*------------------------------------------------------------------------------------*/

- (void)loginDisplayState:(BOOL)a_state
{
	_wwozTextView.hidden = !a_state;
	_usernameTextField.hidden = a_state;
	_passwordTextField.hidden = a_state;
	_loginButton.hidden = a_state;
	_facebookLoginButton.hidden = a_state;
}

/*------------------------------------------------------------------------------------*/

- (void)facebookTimeoutTimerCallback:(NSTimer*)a_timer
{
	if (a_timer == _facebookTimeoutTimer)
	{
		_facebookTimeoutTimer = nil;
	}
}

/*------------------------------------------------------------------------------------*/

- (void)presentRegisterController
{
	RegisterChooseViewController * controller = [[RegisterChooseViewController alloc] initWithNibName:@"RegisterChooseViewController" bundle:nil];
	[self presentViewController:controller animated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)loginButtonAction:(id)sender
{
	if (isNSStringEmptyOrNil(_passwordTextField.text))
	{
		[_passwordTextField becomeFirstResponder];
		return;
	}
	else if (isNSStringEmptyOrNil(_usernameTextField.text))
	{
		[_usernameTextField becomeFirstResponder];
		return;
	}
	
/*
	// Add request login observers
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLoginFinishedNotification:) name:kRequestLoginFinishedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLoginFailedNotification:) name:kRequestLoginFailedNotification object:nil];
	
	// Save username and password for NOLA requests
	[[RequestManager sharedInstance] setUsername:_usernameTextField.text];
	[[RequestManager sharedInstance] setPassword:[_passwordTextField.text md5EncodedString]];
	
	// Add login functionality
*/ 
}

/*------------------------------------------------------------------------------------*/

- (IBAction)retryButtonAction:(id)sender
{
	// Request status
//FIX-ME	[[RequestManager sharedInstance] requestStatus:self];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)closeButtonAction:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/
// Request Login Notifications
/*------------------------------------------------------------------------------------*

- (void)requestLoginFinishedNotification:(NSNotification*)a_notification
{
	// Remove request login observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestLoginFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestLoginFailedNotification object:nil];
}

/*------------------------------------------------------------------------------------*

- (void)requestLoginFailedNotification:(NSNotification*)a_notification
{
	// Remove request login observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestLoginFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestLoginFailedNotification object:nil];
}

/*------------------------------------------------------------------------------------*/
// Facebook Notifications
/*------------------------------------------------------------------------------------*/

- (void)fbDidLoginNotificationCallback:(NSNotification*)a_notification
{
	// Remove facebook login observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFacebookLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFacebookDidNotLoginNotification object:nil];
	
	// Save username and password for NOLA requests
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary * facebookDict = [defaults objectForKey:kFacebookUserDataKey];
	NSString * username = [[facebookDict objectForKey:@"uid"] stringValue];
	[[RequestManager sharedInstance] setUsername:username];
	[[RequestManager sharedInstance] setPassword:[[NSString stringWithFormat:@"@%@@", username] md5EncodedString]];

	// User is logged in
	[((AppDelegate*)[AppDelegate sharedDelegate]) setLoggedIn:YES];

	// Dismiss
	[self dismissViewControllerAnimated:YES completion:nil];

	// Hide busy
	[[AppDelegate sharedDelegate] hideBusyView];
}

/*------------------------------------------------------------------------------------*/

- (void)fbDidNotLoginNotificationCallback:(NSNotification*)a_notification
{
	// Remove facebook login observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFacebookLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFacebookDidNotLoginNotification object:nil];
	
	[[AppDelegate sharedDelegate] hideBusyView];
	
	[[JAMAlert sharedInstance] doOkAlert:@"Facebook"
								 message:@"Login failed"
									data:nil
								delegate:nil];
	
	[self presentRegisterController];
}

/*------------------------------------------------------------------------------------*/
// Textfield / Keyboard
/*------------------------------------------------------------------------------------*/

- (void)keyboardWillShowNotification:(NSNotification *)a_notification
{
	if (self.currTextField == _usernameTextField)
	{
		[self adjustViewAnimated:self.view offset:-45 animated:YES reset:NO];
	}
	else if (self.currTextField == _passwordTextField)
	{
		[self adjustViewAnimated:self.view offset:-100 animated:YES reset:NO];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)keyboardWillHideNotification:(NSNotification *)a_notification
{
	[self adjustViewAnimated:self.view offset:0 animated:YES reset:YES];
}

/*------------------------------------------------------------------------------------*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	if ((isNSStringEmptyOrNil(_passwordTextField.text)) ||
		(isNSStringEmptyOrNil(_usernameTextField.text)))
	{
		if ((self.currTextField == _usernameTextField) &&
			(isNSStringEmptyOrNil(_passwordTextField.text)))
		{
			[self adjustViewAnimated:self.view offset:-100 animated:YES reset:NO];
			[_passwordTextField becomeFirstResponder];
		}
		else if ((self.currTextField == _passwordTextField) &&
				 (isNSStringEmptyOrNil(_usernameTextField.text)))
		{
			[self adjustViewAnimated:self.view offset:-45 animated:YES reset:NO];
			[_usernameTextField becomeFirstResponder];
		}
		
		return NO;
	}

	return [super textFieldShouldEndEditing:textField];
}

/*------------------------------------------------------------------------------------*/

@end
