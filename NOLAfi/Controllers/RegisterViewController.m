/*------------------------------------------------------------------------------------*/
//
//  RegisterViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "JAMAlert.h"
#import "RequestManager.h"
#import "NSString+MD5.h"

/*------------------------------------------------------------------------------------*/

@interface RegisterViewController ()

@property (nonatomic, strong) IBOutlet UITextField * usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField * emailTextField;
@property (nonatomic, strong) IBOutlet UITextField * passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField * verifyPasswordTextField;

@end

/*------------------------------------------------------------------------------------*/

@implementation RegisterViewController

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
	
	self.title = @"Register";
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*------------------------------------------------------------------------------------*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

/*------------------------------------------------------------------------------------*/

- (IBAction)registerButtonAction:(id)sender
{
//	[[RequestManager sharedInstance] requestRegistration:self];
}

/*------------------------------------------------------------------------------------*/
// Textfield / Keyboard
/*------------------------------------------------------------------------------------*/

- (void)keyboardWillShowNotification:(NSNotification *)a_notification
{
	if (self.currTextField == self.usernameTextField)
	{
		[self adjustViewAnimated:self.view offset:-45 animated:YES reset:NO];
	}
	else if (self.currTextField == self.passwordTextField)
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
/*
	if ((isNSStringEmptyOrNil(self.usernameTextField.text)) ||
		(isNSStringEmptyOrNil(self.emailTextField.text)) ||
		(isNSStringEmptyOrNil(self.passwordTextField.text)) ||
		(isNSStringEmptyOrNil(self.verifyPasswordTextField.text)))
	{
		if (self.currTextField == self.usernameTextField) &&
		{
			[self adjustViewAnimated:self.view offset:-100 animated:YES reset:NO];
			[self.passwordTextField becomeFirstResponder];
		}
		else if ((self.currTextField == self.passwordTextField) &&
				 (isNSStringEmptyOrNil(self.usernameTextField.text)))
		{
			[self adjustViewAnimated:self.view offset:-45 animated:YES reset:NO];
			[self.usernameTextField becomeFirstResponder];
		}
		
		return NO;
	}
*/
	
	return [super textFieldShouldEndEditing:textField];
}

/*------------------------------------------------------------------------------------*/

@end
