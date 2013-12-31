/*------------------------------------------------------------------------------------*/
//
//  TestWWOZVenuesDetailsViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestWWOZVenuesDetailsViewController.h"
#import "TestImageViewController.h"
#import "JAMWebViewController.h"

/*------------------------------------------------------------------------------------*/

@interface TestWWOZVenuesDetailsViewController ()

@end

/*------------------------------------------------------------------------------------*/

@implementation TestWWOZVenuesDetailsViewController

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
		
		if (([key isEqualToString:@"path"]) ||
			([key isEqualToString:@"web_site_link"]) ||
			([key isEqualToString:@"lead_image"]))
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

	if ([key isEqualToString:@"lead_image"])
	{
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		
		// Instantiate and setup controller
		TestImageViewController * controller = [[TestImageViewController alloc] initWithNibName:@"TestImageViewController" bundle:nil];
		[controller requestImage:[self.detailDict objectForKey:key]];

		// Push controller
		self.navigationItem.title = key;
		[[self navigationController] pushViewController:controller animated:YES];
	}
	else if (([key isEqualToString:@"web_site_link"] && !isNSStringEmptyOrNil([self.detailDict objectForKey:key])) ||
			 ([key isEqualToString:@"path"] && !isNSStringEmptyOrNil([self.detailDict objectForKey:key])))
	{
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		
		JAMWebViewController * controller = [[JAMWebViewController alloc] initWithNibName:@"JAMWebViewController" bundle:nil];
		[controller.webView loadRequestedUrlWithActivityIndicator:[self.detailDict objectForKey:key]];
		
		self.navigationItem.title = key;
		[[self navigationController] pushViewController:controller animated:YES];
	}
}

/*------------------------------------------------------------------------------------*/

@end
