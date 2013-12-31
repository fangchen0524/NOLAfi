/*------------------------------------------------------------------------------------*/
//
//  TicketsContentView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 5/4/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TicketsContentView.h"
#import "JAMWebView.h"

/*------------------------------------------------------------------------------------*/

@interface TicketsContentView()
{
	IBOutlet JAMWebView * _webView;
	IBOutlet UIButton * _drawerButton;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation TicketsContentView

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	// Add action to button
	[_drawerButton addTarget:self action:@selector(showHideDrawer:) forControlEvents:UIControlEventTouchDown];

	// Load web url
	[_webView loadRequestedUrlWithActivityIndicator:kBusTicketsUrl];

	// Call super
	[super awakeFromNib];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)showHideDrawer:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kHomeShowHideDrawerNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

@end
