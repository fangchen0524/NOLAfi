/*------------------------------------------------------------------------------------*/
//
//  AccountViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "AccountViewController.h"
#import "LoginViewController.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Interface
/*------------------------------------------------------------------------------------*/

@interface AccountViewController ()
{
	IBOutlet UIScrollView * _scrollView;
	IBOutlet UIView * _accountInfoView;
	IBOutlet UIView * _newLoginView;
	IBOutlet UIImageView * _backgroundImageView;
	IBOutlet UIImageView * _facebookImageView;
	IBOutlet UITextField * _userNameTextField;
	IBOutlet UITextField * _emailTextField;
}
@end

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
/*------------------------------------------------------------------------------------*/

@implementation AccountViewController

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
	
	_scrollView.contentSize = _scrollView.frame.size;

	_newLoginView.hidden = !self.newLogin;
}

/*------------------------------------------------------------------------------------*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	_accountInfoView.hidden = YES;
	_backgroundImageView.hidden = YES;
	
	if (self.displayInfo)
	{
		_accountInfoView.hidden = NO;
		_newLoginView.hidden = YES;
		_backgroundImageView.hidden = NO;
		
		NSDictionary * facebookDict = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookUserDataKey];
		NSString * fileName = [[facebookDict objectForKey:@"pic_big"] lastPathComponent];
		NSString * file = [fileName stringByDeletingPathExtension];
		NSString * ext = [fileName pathExtension];
		NSString * filePath = [JAMAppDelegate obtainResourcePath:file ofType:ext searchPathDirectory:NSDocumentDirectory destinationPath:@"Facebook" overWrite:NO];
		UIImage * image = [UIImage imageWithContentsOfFile:filePath];
		self.pictureImageView.image = image;
		self.pictureImageView.layer.cornerRadius = 8;
		self.pictureImageView.layer.masksToBounds = YES;

		_facebookImageView.layer.cornerRadius = 4;
		_facebookImageView.layer.masksToBounds = YES;
		
		_userNameTextField.text = [NSString stringWithFormat:@"%@ %@",
								   [facebookDict objectForKey:@"first_name"],
								   [facebookDict objectForKey:@"last_name"]];
		_emailTextField.text = [facebookDict objectForKey:@"email"];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (([[AppDelegate sharedDelegate] loggedIn]) &&
		(!self.displayInfo))
	{
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else if (!self.displayInfo)
	{
		// Auto login, if user already athenticated to Facebook
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults objectForKey:kFacebookAuthenticationKey])
		{
			[self facebookLoginButtonAction:nil];
		}
	}
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

- (IBAction)emailLoginButtonAction:(id)sender
{
	LoginViewController * controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	controller.loginType = kLoginTypeNawlin;
	[self presentViewController:controller animated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)facebookLoginButtonAction:(id)sender
{
	LoginViewController * controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	controller.loginType = kLoginTypeFacebook;
	[self presentViewController:controller animated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

@end
