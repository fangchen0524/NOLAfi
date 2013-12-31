/*------------------------------------------------------------------------------------*/
//
//  TicketTableViewCell.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/16/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TicketTableViewCell.h"

/*------------------------------------------------------------------------------------*/

@interface TicketTableViewCell()
{
	
}
@end

/*------------------------------------------------------------------------------------*/

@implementation TicketTableViewCell

/*------------------------------------------------------------------------------------*/

- (id)init
{
	self = [super init];
	
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self)
	{
		[self initCommon];
    }
	
    return self;
}

/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	// Do nothing
}

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	[super awakeFromNib];
}

/*------------------------------------------------------------------------------------*/

- (void)dealloc
{
	// Do nothing
}

/*------------------------------------------------------------------------------------*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*------------------------------------------------------------------------------------*/

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSEnumerator * reverseE = [self.subviews reverseObjectEnumerator];
    UIView * iSubView = nil;
    while ((iSubView = [reverseE nextObject]))
	{
        UIView * viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if (viewWasHit)
		{
            return viewWasHit;
        }
    }
	
    return [super hitTest:point withEvent:event];
}

/*------------------------------------------------------------------------------------*/

@end
