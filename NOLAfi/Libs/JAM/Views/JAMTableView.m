/*------------------------------------------------------------------------------------*/
//
//  JAMTableView.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMTableView.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Interface
/*------------------------------------------------------------------------------------*/

@interface JAMTableView() <UITableViewDelegate, UITableViewDataSource>

@end

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
/*------------------------------------------------------------------------------------*/

@implementation JAMTableView

/*------------------------------------------------------------------------------------*/
#pragma mark - Override Methods
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

/*----------------------------------------------------------------------------------------------------------*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initCommon];
    }
    
    return self;
}

/*----------------------------------------------------------------------------------------------------------*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initCommon];
    }
    
    return self;
}

/*----------------------------------------------------------------------------------------------------------*/

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
        [self initCommon];
    }
    
    return self;
}

/*----------------------------------------------------------------------------------------------------------*/

- (void)initCommon
{
    self.delegate = self;
    self.dataSource = self;
}

/*----------------------------------------------------------------------------------------------------------*/
#pragma mark - UITableViewDataSource Methods
/*----------------------------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

/*----------------------------------------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

/*----------------------------------------------------------------------------------------------------------*/
#pragma mark - Touch Methods
/*----------------------------------------------------------------------------------------------------------*

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Determine which cel view was touched
    UITouch * touch = [touches anyObject];
    CGPoint firstTouch = [touch locationInView:self];
    NSEnumerator * viewEnum = [self.subviews reverseObjectEnumerator];
    UIView * iView = nil;
    while ((iView = [viewEnum nextObject]))
	{
		if (([iView isKindOfClass:[UITableViewCell class]]) &&
			(CGRectContainsPoint(iView.frame, firstTouch)))
		{
			// Determine if a subview of the cell was touched
			firstTouch = [touch locationInView:iView];
			NSEnumerator * subViewEnum = [iView.subviews reverseObjectEnumerator];
			UIView * iSubView = nil;
			while ((iSubView = [subViewEnum nextObject]))
			{
				if (CGRectContainsPoint(iSubView.frame, firstTouch))
				{
					// Found the touched view in the cell
					_touchedView = iSubView;
					return;
				}
			}
		}
    }
    
    // Forward touches
    [super touchesBegan:touches withEvent:event];
}

//------------------------------------------------------------------------------------*/

@end