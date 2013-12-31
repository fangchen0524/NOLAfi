/*------------------------------------------------------------------------------------*/
//
//  HomeDrawerView.m
//  FacebookStyle
//
//  Created by Jonathan Morin on 12/29/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "HomeDrawerView.h"
#import "AccountTableViewCell.h"
#import "FavoritesTableViewCell.h"
#import "JAMTableView.h"

/*------------------------------------------------------------------------------------*/

#define USE_SHADOWS		0

#define SHOW_SEARCH		1
#define SHOW_TICKETS	1

/*------------------------------------------------------------------------------------*/

@interface HomeDrawerView() < UITableViewDelegate, UITableViewDataSource >
{
	IBOutlet JAMTableView * _tableView;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation HomeDrawerView

/*------------------------------------------------------------------------------------*/

enum
{
	kAccountAction = 0,
	kConciergeAction,
	kEventsAction,
	kPlacesAction,
#if SHOW_TICKETS
	kTicketsAction,
#endif // #if SHOW_TICKETS
#if SHOW_SEARCH
	kSearchAction,
#endif // #if SHOW_SEARCH
	kAboutAction,
    kFavoritesNoAction,
	
	// ADD NEW ACTIONS ABOVE HERE
#if DEBUG
	kTestWWOZVenuesAction,
	kTestWWOZEventsAction,
	kTestNOLAPlacesAction,
	kTestSaveOrderAction,
	kTestProductsAction,
	kTestArtistsAction,
#if USE_PAYPAL
	kTestPayPalAction,
#endif // #if USE_PAYPAL
#endif // #if DEBUG
	
	// KEEP AT THE BOTTOM
	kNumActions
};

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	[super awakeFromNib];
	
#if USE_SHADOWS
	_tableView.layer.shadowColor = [[UIColor blackColor] CGColor];
	_tableView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
	_tableView.layer.shadowOpacity = 0.75;
#endif // #if USE_SHADOWS
}

/*------------------------------------------------------------------------------------*/
// UITableViewDelegate, UITableViewDataSource
/*------------------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return kNumActions;
}

/*------------------------------------------------------------------------------------*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == kAccountAction)
	{
		return 46;
	}
	else if (indexPath.row == kFavoritesNoAction)
	{
		return 49;
	}
	else if (indexPath.row > kFavoritesNoAction)
	{
		return 65;
	}
	else
	{
		return 51;
	}
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * sGenericCellIdentifier = @"GenericCellIdentifier";
	static NSString * sAccountCellIdentifier = @"AccountCellIdentifier";
	static NSString * sFavoriteCellIdentifier = @"sFavoriteCellIdentifier";

	static NSString * sImageNames[] = {
		nil,						// kAccountAction
		@"drawer-concierge.jpg",	// kConciergeAction
		@"drawer-events.jpg",		// kEventsAction
		@"drawer-places.jpg",		// kPlacesAction
#if SHOW_TICKETS
		@"drawer-tickets.jpg",		// kTicketsAction
#endif // #if SHOW_TICKETS
#if SHOW_SEARCH
		@"drawer-search.jpg",		// kSearchAction
#endif // #if SHOW_SEARCH
		@"drawer-about.jpg",		// kAboutAction
		@"drawer-favorites.jpg",	// kFavoritesNoAction
	};
	
#if DEBUG
	static NSString * sTestActions[] = {
		@"Test WWOZ Venues",		// kTestWWOZVenuesAction
		@"Test WWOZ Events",		// kTestWWOZEventsAction
		@"Test NOLA Places",		// kTestNOLAPlacesAction
		@"Test Order Save",			// kTestSaveOrderAction
		@"Test Products",			// kTestProductsAction
		@"Test Artist Pictures",	// kTestArtistsAction
#if USE_PAYPAL
		@"Test PayPal",				// kTestPayPalAction
#endif // #if USE_PAYPAL
	};
#endif // #if DEBUG
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sGenericCellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sGenericCellIdentifier];
		cell.imageView.contentMode = UIViewContentModeLeft;
		cell.backgroundColor = [UIColor colorWithRed:(35 / 255) green:(36 / 255) blue:(22 / 255) alpha:1.0];
	}
	
	if (indexPath.row == kAccountAction)
	{
		AccountTableViewCell * accountCell = [tableView dequeueReusableCellWithIdentifier:sAccountCellIdentifier];
		if (!accountCell)
		{
			NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:self options:nil];
			accountCell = (AccountTableViewCell*)[nib objectAtIndex:0];
			accountCell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		cell = accountCell;
	}
	else if (indexPath.row > kFavoritesNoAction)
	{
		FavoritesTableViewCell * favoritesCell = [tableView dequeueReusableCellWithIdentifier:sFavoriteCellIdentifier];
		if (!favoritesCell)
		{
			NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"FavoritesTableViewCell" owner:self options:nil];
			favoritesCell = (FavoritesTableViewCell*)[nib objectAtIndex:0];
			favoritesCell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
#if DEBUG
		favoritesCell.favoriteTitle.text = sTestActions[(indexPath.row - (kFavoritesNoAction + 1))];
#endif // #if DEBUG
		
		cell = favoritesCell;
	}
	else
	{
		cell.imageView.image = [UIImage imageNamed:sImageNames[indexPath.row]];
	}
	
	return cell;
}

/*------------------------------------------------------------------------------------*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];

	static NSString * buttonNotifications[] = {
		kAccountButtonNotification,			// kAccountAction
		kConciergeButtonNotification,		// kConciergeAction
		kEventsButtonNotification,			// kEventsAction
		kPlacesButtonNotification,			// kPlacesAction
#if SHOW_TICKETS
		kTicketsButtonNotification,			// kTicketsAction
#endif // #if SHOW_TICKETS
#if SHOW_SEARCH
		kSearchButtonNotification,			// kSearchAction
#endif // #if SHOW_SEARCH
		kAboutButtonNotification,			// kAboutAction
		nil,								// kFavoritesNoAction
#if DEBUG
		kTestWWOZVenuesButtonNotification,	// kTestWWOZVenuesAction
		kTestWWOZEventsButtonNotification,	// kTestWWOZEventsAction
		kTestNOLAPlacesButtonNotification,	// kTestNOLAPlacesAction
		kTestOrderSaveButtonNotification,	// kTestSaveOrderAction
		kTestProductsButtonNotification,	// kTestProductsAction
		kTestArtistsButtonNotification,		// kTestArtistsProductsAction
#if USE_PAYPAL
		kTestPayPalButtonNotification,		// kTestPayPalAction
#endif // #if USE_PAYPAL
#endif // #if DEBUG
	};

	// Post notification
	if (!isNSStringEmptyOrNil(buttonNotifications[indexPath.row]))
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:buttonNotifications[indexPath.row] object:self userInfo:nil];
	}
	
	cell.selected = NO;
}

/*------------------------------------------------------------------------------------*/

@end
