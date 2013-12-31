/*------------------------------------------------------------------------------------*/
//
//  JAMView.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMView.h"

@interface JAMView()

@property (nonatomic, assign) BOOL awake;

@end

/*------------------------------------------------------------------------------------*/

@implementation JAMView

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
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
	// Do nothing
}

/*------------------------------------------------------------------------------------*/

@end
