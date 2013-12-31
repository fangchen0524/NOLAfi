/*------------------------------------------------------------------------------------*/
//
//  ConciergeQuestionsTableViewCell.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/19/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "ConciergeQuestionsTableViewCell.h"
#import "JAMBitmap.h"

/*------------------------------------------------------------------------------------*/

@implementation ConciergeQuestionsTableViewCell

/*------------------------------------------------------------------------------------*/

- (IBAction)buttonAction:(id)sender
{
	_button.selected = !_button.selected;

	// Post selected notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kConciergeSelectedNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

@end
