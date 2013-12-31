/*------------------------------------------------------------------------------------*/
//
//  TestArtistsDetailsViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestArtistsDetailsViewController.h"
#import "TestImageViewController.h"
#import "JAMWebViewController.h"

/*------------------------------------------------------------------------------------*/

@interface TestArtistsDetailsViewController ()

@end

/*------------------------------------------------------------------------------------*/

@implementation TestArtistsDetailsViewController

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
	static NSString * cellIdentifier = @"CellIdentifier";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSArray * allKeys = [self.detailDict allKeys];
	NSString * key = [allKeys objectAtIndex:indexPath.row];
	cell.textLabel.text = key;
	
	cell.detailTextLabel.text = nil;
	id obj = [self.detailDict objectForKey:key];
	if (([obj isKindOfClass:[NSString class]]) &&
		(!isNSStringEmptyOrNil(obj)))
	{
		cell.detailTextLabel.text = [self.detailDict objectForKey:key];
	}
	else if ([obj isKindOfClass:[NSArray class]])
	{
		if ([key isEqualToString:@"images"])
		{
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
	}
	
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
	UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	if (cell.accessoryType == UITableViewCellAccessoryDetailDisclosureButton)
	{
		[self selectTableViewRow:tableView indexPath:indexPath];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)selectTableViewRow:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
	NSArray * allKeys = [self.detailDict allKeys];
	NSString * key = [allKeys objectAtIndex:indexPath.row];
	
	if ([key isEqualToString:@"images"])
	{
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		
		// Instantiate and setup controller
		TestImageViewController * controller = [[TestImageViewController alloc] initWithNibName:@"TestImageViewController" bundle:nil];
		if (([[self.detailDict objectForKey:key] count]) &&
			(!isNSStringEmptyOrNil([[[self.detailDict objectForKey:key] objectAtIndex:0] objectForKey:@"image"])))
		{
			[controller requestImage:[[[self.detailDict objectForKey:key] objectAtIndex:0] objectForKey:@"image"]];
		}
		
		// Push controller
		self.navigationItem.title = key;
		[[self navigationController] pushViewController:controller animated:YES];
	}
}

/*------------------------------------------------------------------------------------*/

@end
