/*------------------------------------------------------------------------------------*/
//
//  TestWWOZVenuesViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestWWOZVenuesViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "TestWWOZVenuesDetailsViewController.h"
#import "RequestManager.h"

/*------------------------------------------------------------------------------------*/

@interface TestWWOZVenuesViewController() < UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate >

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

@property (nonatomic, strong) NSMutableDictionary * filteredVenuesDict;

@end

/*------------------------------------------------------------------------------------*/

@implementation TestWWOZVenuesViewController

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"WWOZ Venues";
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*------------------------------------------------------------------------------------*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = NO;
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
	if (self.filteredVenuesDict)
	{
		return self.filteredVenuesDict.count;
	}
	else
	{
		return ((AppDelegate*)[AppDelegate sharedDelegate]).wwozVenuesDict.allKeys.count;
	}
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"VenueCell";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	NSDictionary * dict = ((AppDelegate*)[AppDelegate sharedDelegate]).wwozVenuesDict;
	if (self.filteredVenuesDict)
	{
		dict = self.filteredVenuesDict;
	}
	
	NSArray * allKeys = [dict allKeys];
	NSArray * sortedKeyArray = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		NSString * first = [[dict objectForKey:a] objectForKey:@"title"];
		NSString * second = [[dict objectForKey:b] objectForKey:@"title"];
		return [first compare:second];
	}];
	allKeys = sortedKeyArray;
	
	cell.textLabel.text = [[dict objectForKey:[allKeys objectAtIndex:indexPath.row]] objectForKey:@"title"];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.detailTextLabel.text = nil;
	if (!isNSStringEmptyOrNil([[dict objectForKey:[allKeys objectAtIndex:indexPath.row]] objectForKey:@"lead_image"]))
	{
		cell.detailTextLabel.text = [[dict objectForKey:[allKeys objectAtIndex:indexPath.row]] objectForKey:@"lead_image"];
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
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	TestWWOZVenuesDetailsViewController * controller = [[TestWWOZVenuesDetailsViewController alloc] initWithNibName:@"TestWWOZVenuesDetailsViewController" bundle:nil];
	
	NSDictionary * dict = ((AppDelegate*)[AppDelegate sharedDelegate]).wwozVenuesDict;
	if (self.filteredVenuesDict)
	{
		dict = self.filteredVenuesDict;
	}
	
	NSArray * allKeys = [dict allKeys];
	NSArray * sortedKeyArray = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		NSString * first = [[dict objectForKey:a] objectForKey:@"title"];
		NSString * second = [[dict objectForKey:b] objectForKey:@"title"];
		return [first compare:second];
	}];
	allKeys = sortedKeyArray;
	
	controller.detailDict = [dict objectForKey:[allKeys objectAtIndex:indexPath.row]];
	controller.title = [[dict objectForKey:[allKeys objectAtIndex:indexPath.row]] objectForKey:@"title"];
	[[self navigationController] pushViewController:controller animated:YES];
}

/*------------------------------------------------------------------------------------*/
// UISearchBarDelegate
/*------------------------------------------------------------------------------------*/

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
}

/*------------------------------------------------------------------------------------*/

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self filterByString:searchText];
}

/*------------------------------------------------------------------------------------*/

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	
	[self filterByString:searchBar.text];
}

/*------------------------------------------------------------------------------------*/

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	
	[self filterByString:searchBar.text];
}

/*------------------------------------------------------------------------------------*/

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	[searchBar resignFirstResponder];
	
	self.filteredVenuesDict = nil;
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

- (void)filterByString:(NSString*)a_filter
{
	if (!self.filteredVenuesDict)
	{
		self.filteredVenuesDict = [[NSMutableDictionary alloc] init];
	}
	[self.filteredVenuesDict removeAllObjects];
	
	if (!isNSStringEmptyOrNil(a_filter))
	{
		for (id key in [((AppDelegate*)[AppDelegate sharedDelegate]).wwozVenuesDict allKeys])
		{
			NSDictionary * dict = [((AppDelegate*)[AppDelegate sharedDelegate]).wwozVenuesDict objectForKey:key];
			NSString * name = [dict objectForKey:@"title"];
			if ([name rangeOfString:a_filter options: NSCaseInsensitiveSearch].length)
			{
				[self.filteredVenuesDict setObject:dict forKey:key];
			}
		}
	}
	else
	{
		self.filteredVenuesDict = nil;
	}
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

@end
