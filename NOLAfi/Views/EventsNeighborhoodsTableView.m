/*------------------------------------------------------------------------------------*/
//
//  EventsNeighborhoodsTableView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/21/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "EventsNeighborhoodsTableView.h"

/*------------------------------------------------------------------------------------*/

@interface EventsNeighborhoodsTableView() <UITableViewDelegate, UITableViewDataSource>

@end

/*------------------------------------------------------------------------------------*/

@implementation EventsNeighborhoodsTableView

/*------------------------------------------------------------------------------------*/

static NSString * sNeighborhoods[] = {
	@"FRENCH QUARTER / CBD",
	@"CENTRAL CITY / GARDEN DISTRICT AREA",
	@"UPTOWN / CARROLLTON AREA",
	@"MID-CITY AREA",
	@"LAKEVIEW AREA",
	@"GENTILLY AREA",
	@"BYWATER AREA",
	@"LOWER NINTH WARE AREA",
	@"NEW ORLEANS EAST AREA",
	@"VILLAGE DE L'EST",
	@"VENETIAN ISLES / LAKE CATHERINE",
	@"ALGIERS AREA",
	@"ENGLISH TURN AREA",
	
};
static NSInteger sNumNeighborhoods = (sizeof(sNeighborhoods) / sizeof(NSString*));

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
	return sNumNeighborhoods;
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
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:14];
		cell.textLabel.textColor = [UIColor whiteColor];
	}

	cell.textLabel.text = sNeighborhoods[indexPath.row];
	
	return cell;
}

/*------------------------------------------------------------------------------------*/

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self selectTableViewRow:tableView indexPath:indexPath];
}

/*------------------------------------------------------------------------------------*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self selectTableViewRow:tableView indexPath:indexPath];
}

/*------------------------------------------------------------------------------------*/

- (void)selectTableViewRow:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];

	UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryCheckmark;
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
	{
		accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.accessoryType = accessoryType;
	
	cell.selected = NO;
}

/*------------------------------------------------------------------------------------*/

@end
