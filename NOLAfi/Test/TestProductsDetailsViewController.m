/*------------------------------------------------------------------------------------*/
//
//  TestProductsDetailsViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestProductsDetailsViewController.h"
#import "JSON.h"
#import "AppDelegate.h"

/*------------------------------------------------------------------------------------*/

@interface TestProductsDetailsViewController ()

@end

/*------------------------------------------------------------------------------------*/

@implementation TestProductsDetailsViewController

/*------------------------------------------------------------------------------------*/

@synthesize tableView = _tableView;

@synthesize detailDict = _detailDict;

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*------------------------------------------------------------------------------------*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

/*------------------------------------------------------------------------------------*/
// UITableViewDataSource
/*------------------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.detailDict.allKeys.count;
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"PlaceCell";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	NSArray * allKeys = [self.detailDict allKeys];
	NSString * key = [allKeys objectAtIndex:indexPath.row];
	cell.textLabel.text = key;
	id obj = [self.detailDict objectForKey:key];
	if ([obj isKindOfClass:[NSString class]])
	{
		cell.detailTextLabel.text = [self.detailDict objectForKey:key];
	}
	
	return cell;
}

/*------------------------------------------------------------------------------------*/

@end
