/*------------------------------------------------------------------------------------*/
//
//  TestArtistsViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestArtistsViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "TestArtistsDetailsViewController.h"

/*------------------------------------------------------------------------------------*/

@interface TestArtistsViewController() < UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate >

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

@property (nonatomic, strong) NSMutableArray * filteredArtistsArray;

@end

/*------------------------------------------------------------------------------------*/

@implementation TestArtistsViewController

/*------------------------------------------------------------------------------------*/

@synthesize tableView = _tableView;

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Artist Pictures";
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
	if (self.filteredArtistsArray)
	{
		return self.filteredArtistsArray.count;
	}
	else
	{
		return ((AppDelegate*)[AppDelegate sharedDelegate]).artistsArray.count;
	}
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"ArtistCell";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	NSArray * array = ((AppDelegate*)[AppDelegate sharedDelegate]).artistsArray;
	if (self.filteredArtistsArray)
	{
		array = self.filteredArtistsArray;
	}
	
	cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.detailTextLabel.text = nil;
	if (([[[array objectAtIndex:indexPath.row] objectForKey:@"images"] count]) &&
		(!isNSStringEmptyOrNil([[[[array objectAtIndex:indexPath.row] objectForKey:@"images"] objectAtIndex:0] objectForKey:@"image"])))
	{
		cell.detailTextLabel.text = [[[[array objectAtIndex:indexPath.row] objectForKey:@"images"] objectAtIndex:0] objectForKey:@"image"];;
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
	
	TestArtistsDetailsViewController * controller = [[TestArtistsDetailsViewController alloc] initWithNibName:@"TestArtistsDetailsViewController" bundle:nil];
	
	NSArray * array = ((AppDelegate*)[AppDelegate sharedDelegate]).artistsArray;
	if (self.filteredArtistsArray)
	{
		array = self.filteredArtistsArray;
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
	
	self.filteredArtistsArray = nil;
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

- (void)filterByString:(NSString*)a_filter
{
	if (!self.filteredArtistsArray)
	{
		self.filteredArtistsArray = [[NSMutableArray alloc] init];
	}
	[self.filteredArtistsArray removeAllObjects];
	
	if (!isNSStringEmptyOrNil(a_filter))
	{
		for (NSDictionary * dict in ((AppDelegate*)[AppDelegate sharedDelegate]).artistsArray)
		{
			NSString * name = [dict objectForKey:@"name"];
			if ([name rangeOfString:a_filter options: NSCaseInsensitiveSearch].length)
			{
				[self.filteredArtistsArray addObject:dict];
			}
		}
		
		NSArray * sortedArray = [self.filteredArtistsArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
			NSString * first = [a objectForKey:@"name"];
			NSString * second = [b objectForKey:@"name"];
			return [first compare:second];
		}];
		self.filteredArtistsArray = [sortedArray mutableCopy];
	}
	else
	{
		self.filteredArtistsArray = nil;
	}
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

@end
