/*------------------------------------------------------------------------------------*/
//
//  TestPlacesViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestPlacesViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "TestPlacesDetailsViewController.h"

/*------------------------------------------------------------------------------------*/

@interface TestPlacesViewController() < UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate >

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

@property (nonatomic, strong) NSMutableArray * filteredPlacesArray;

@end

/*------------------------------------------------------------------------------------*/

@implementation TestPlacesViewController

/*------------------------------------------------------------------------------------*/

@synthesize tableView = _tableView;

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"NOLA Places";
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
	if (self.filteredPlacesArray)
	{
		return self.filteredPlacesArray.count;
	}
	else
	{
		return ((AppDelegate*)[AppDelegate sharedDelegate]).placesArray.count;
	}
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
	
	NSArray * array = ((AppDelegate*)[AppDelegate sharedDelegate]).placesArray;
	if (self.filteredPlacesArray)
	{
		array = self.filteredPlacesArray;
	}
	
	cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.detailTextLabel.text = nil;
	if (!isNSStringEmptyOrNil([[array objectAtIndex:indexPath.row] objectForKey:@"image"]))
	{
		cell.detailTextLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"image"];
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
	
	TestPlacesDetailsViewController * controller = [[TestPlacesDetailsViewController alloc] initWithNibName:@"TestPlacesDetailsViewController" bundle:nil];
	
	NSArray * array = ((AppDelegate*)[AppDelegate sharedDelegate]).placesArray;
	if (self.filteredPlacesArray)
	{
		array = self.filteredPlacesArray;
	}
	
	controller.detailDict = [array objectAtIndex:indexPath.row];
	controller.title = [[array objectAtIndex:indexPath.row] objectForKey:@"name"];
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
	
	self.filteredPlacesArray = nil;
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

- (void)filterByString:(NSString*)a_filter
{
	if (!self.filteredPlacesArray)
	{
		self.filteredPlacesArray = [[NSMutableArray alloc] init];
	}
	[self.filteredPlacesArray removeAllObjects];
	
	if (!isNSStringEmptyOrNil(a_filter))
	{
		for (NSDictionary * dict in ((AppDelegate*)[AppDelegate sharedDelegate]).placesArray)
		{
			NSString * name = [dict objectForKey:@"name"];
			if ([name rangeOfString:a_filter options: NSCaseInsensitiveSearch].length)
			{
				[self.filteredPlacesArray addObject:dict];
			}
		}
		
		NSArray * sortedArray = [self.filteredPlacesArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
			NSString * first = [a objectForKey:@"name"];
			NSString * second = [b objectForKey:@"name"];
			return [first compare:second];
		}];
		self.filteredPlacesArray = [sortedArray mutableCopy];
	}
	else
	{
		self.filteredPlacesArray = nil;
	}
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

@end
