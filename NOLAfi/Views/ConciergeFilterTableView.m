/*------------------------------------------------------------------------------------*/
//
//  ConciergeFilterTableView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/21/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "ConciergeFilterTableView.h"

/*------------------------------------------------------------------------------------*/

@interface ConciergeFilterTableView() <UITableViewDelegate, UITableViewDataSource>

@end

/*------------------------------------------------------------------------------------*/

@implementation ConciergeFilterTableView

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

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	self.delegate = self;
	self.dataSource = self;
	
	self.conciergeFilterArray = [[NSMutableArray alloc] init];
}

/*------------------------------------------------------------------------------------*/

- (void)dealloc
{
	self.delegate = nil;
	self.dataSource = nil;
}

/*------------------------------------------------------------------------------------*/
// UITableViewDelegate / UITableViewDataSource
/*------------------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.conciergeFilterArray.count;
}

/*------------------------------------------------------------------------------------*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * sCellIdentifier = @"CellIdentifier";
	
	UITableViewCell * cell = [self dequeueReusableCellWithIdentifier:sCellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:14];
		cell.textLabel.textColor = [UIColor whiteColor];
	}

	cell.textLabel.text = [self.conciergeFilterArray objectAtIndex:indexPath.row];
	
	return cell;
}

/*------------------------------------------------------------------------------------*/

@end
