/*------------------------------------------------------------------------------------*/
//
//  TestProductsViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TestProductsViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "TestProductsDetailsViewController.h"
#import "RequestManager.h"

/*------------------------------------------------------------------------------------*/

@interface TestProductsViewController() < UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate >

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

@property (nonatomic, strong) NSMutableDictionary * filteredDict;

@end

/*------------------------------------------------------------------------------------*/

@implementation TestProductsViewController

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Products";
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
	if (self.filteredDict)
	{
		return self.filteredDict.count;
	}
	else
	{
		return ((AppDelegate*)[AppDelegate sharedDelegate]).productsDict.allKeys.count;
	}
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"CellIdentifier";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] init];
	}
	
	NSDictionary * dict = ((AppDelegate*)[AppDelegate sharedDelegate]).productsDict;
	if (self.filteredDict)
	{
		dict = self.filteredDict;
	}
	
	NSArray * allKeys = [dict allKeys];
	cell.textLabel.text = [[dict objectForKey:[allKeys objectAtIndex:indexPath.row]] objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
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
	
	TestProductsDetailsViewController * controller = [[TestProductsDetailsViewController alloc] initWithNibName:@"TestProductsDetailsViewController" bundle:nil];
	
	NSDictionary * dict = ((AppDelegate*)[AppDelegate sharedDelegate]).productsDict;
	if (self.filteredDict)
	{
		dict = self.filteredDict;
	}
	
	NSArray * allKeys = [dict allKeys];
	controller.detailDict = [dict objectForKey:[allKeys objectAtIndex:indexPath.row]];
	controller.title = [[dict objectForKey:[allKeys objectAtIndex:indexPath.row]] objectForKey:@"name"];
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
	
	self.filteredDict = nil;
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

- (void)filterByString:(NSString*)a_filter
{
	if (!self.filteredDict)
	{
		self.filteredDict = [[NSMutableDictionary alloc] init];
	}
	[self.filteredDict removeAllObjects];
	
	if (!isNSStringEmptyOrNil(a_filter))
	{
		for (id key in [((AppDelegate*)[AppDelegate sharedDelegate]).productsDict allKeys])
		{
			NSDictionary * dict = [((AppDelegate*)[AppDelegate sharedDelegate]).productsDict objectForKey:key];
			NSString * name = [dict objectForKey:@"name"];
			if ([name rangeOfString:a_filter options: NSCaseInsensitiveSearch].length)
			{
				[self.filteredDict setObject:dict forKey:key];
			}
		}
	}
	else
	{
		self.filteredDict = nil;
	}
	
	[self.tableView reloadData];
}

/*------------------------------------------------------------------------------------*/

@end
