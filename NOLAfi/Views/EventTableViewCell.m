/*------------------------------------------------------------------------------------*/
//
//  EventTableViewCell.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/19/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "EventTableViewCell.h"
#import "EventDetailViewController.h"

/*------------------------------------------------------------------------------------*/

#define USE_SHADOWS	0

/*------------------------------------------------------------------------------------*/

@interface EventTableViewCell()
{
	IBOutlet UIButton * _starButton;
	
	BOOL _starState;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation EventTableViewCell

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	[super awakeFromNib];

#if USE_SHADOWS
	self.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
	self.layer.shadowOpacity = 0.75;
#endif // #if USE_SHADOWS
}

/*------------------------------------------------------------------------------------*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*------------------------------------------------------------------------------------*/

- (IBAction)starButtonAction:(id)sender
{
	_starState = !_starState;
	_starButton.selected = _starState;
}

/*------------------------------------------------------------------------------------*/

- (IBAction)detailButtonAction:(id)sender
{
	EventDetailViewController * controller = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController" bundle:nil];
	controller.eventDict = self.eventDict;
	[self.parentViewController.navigationController pushViewController:controller animated:YES];
}

/*------------------------------------------------------------------------------------*/

@end
