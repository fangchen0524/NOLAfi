/*------------------------------------------------------------------------------------*/
//
//  HomeContentView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 5/2/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "HomeContentView.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

/*------------------------------------------------------------------------------------*/

@implementation HomeContentView

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.interactionOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT)];
	self.interactionOverlay.hidden = YES;
	[self addSubview:self.interactionOverlay];
}

/*------------------------------------------------------------------------------------*/

@end
