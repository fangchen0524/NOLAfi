/*------------------------------------------------------------------------------------*/
//
//  JAMTableViewCell.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/30/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMTableViewCell.h"

/*------------------------------------------------------------------------------------*/

@implementation JAMTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*------------------------------------------------------------------------------------*/

@end
