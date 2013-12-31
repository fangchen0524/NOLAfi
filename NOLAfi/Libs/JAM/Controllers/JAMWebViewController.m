/*------------------------------------------------------------------------------------*/
//
//  JAMWebViewController.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMWebViewController.h"

/*------------------------------------------------------------------------------------*/

@interface JAMWebViewController ()
{
	// Nothing
}
@end

/*------------------------------------------------------------------------------------*/

@implementation JAMWebViewController

/*------------------------------------------------------------------------------------*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self)
	{
		// Force load
		[self view];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (id)initWithNibNameAndHeader:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil header:(UIView*)a_header
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self)
	{
		self.header = a_header;
		
		// Force load
		[self view];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (self.header)
	{
		CGRect headerFrame = self.header.frame;
		headerFrame.origin.x = 0;
		headerFrame.origin.y = 0;
		self.header.frame = headerFrame;
		[self.view addSubview:self.header];
		[self.view bringSubviewToFront:self.header];
		
		CGRect webViewFrame = self.webView.frame;
		webViewFrame.origin.y = (headerFrame.origin.y + headerFrame.size.height);
		webViewFrame.size.height -= headerFrame.size.height;
		self.webView.frame = webViewFrame;
	}
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidUnload
{
	self.webView = nil;
}

/*------------------------------------------------------------------------------------*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------------------------------------------------------------------------*/

@end
