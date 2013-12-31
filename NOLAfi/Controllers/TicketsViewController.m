/*------------------------------------------------------------------------------------*/
//
//  TicketsViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"

/*------------------------------------------------------------------------------------*/

@interface TicketsViewController() <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
	IBOutlet UITableView * _tableView;
	IBOutlet UIView * _ticketOverlayView;
	IBOutlet UIButton * _mapButton;
	IBOutlet UIButton * _ticketButton;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation TicketsViewController

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];

	_mapButton.selected = NO;
	_ticketButton.selected = YES;
	_ticketOverlayView.hidden = NO;
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

- (IBAction)backButtonAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)mapButtonAction:(id)sender
{
	_mapButton.selected = YES;
	_ticketButton.selected = NO;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:kDefaultAnimationDuration
						 animations:^{
							 _ticketOverlayView.alpha = 0.0;
						 }
						 completion:^(BOOL finished){
							 _ticketOverlayView.hidden = YES;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/

- (IBAction)ticketButtonAction:(id)sender
{
	_mapButton.selected = NO;
	_ticketButton.selected = YES;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:kDefaultAnimationDuration
						 animations:^{
							 _ticketOverlayView.hidden = NO;
							 _ticketOverlayView.alpha = 1.0;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/
// UITableViewDataSource
/*------------------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

/*------------------------------------------------------------------------------------*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 64;
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * sCellIdentifier = @"TicketCellIdentifier";
	
	static NSString * sProducts[][2] = {
		@"Adult Internet Rate\n48 Hours\n(Ages 13-59)", @"$49.95",
		@"Senior Rate\n48 Hours\n(Ages 60+)", @"$39.95",
		@"Student Rate\n48 Hours\n(Valid Student ID Required)", @"$29.95",
		@"Child Rate\n48 Hours\n(Ages 3-12)", @"$29.95",
		@"Family Rate\n48 Hours\n (2 Adults & Up to 3 Children)", @"$149.95",
	};
	
	TicketTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
	if (!cell)
	{
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TicketTableViewCell" owner:self options:nil];
		cell = (TicketTableViewCell*)[nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	cell.productLabel.text = sProducts[indexPath.row][0];
	cell.priceLabel.text = sProducts[indexPath.row][1];
	
	return cell;
}

/*------------------------------------------------------------------------------------*/

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
	[headerView setBackgroundColor:[UIColor darkGrayColor]];
	 
	UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width, 34)];
	title.backgroundColor = [UIColor clearColor];
	title.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
	title.textColor = [UIColor whiteColor];
	title.textAlignment = UITextAlignmentLeft;
	title.numberOfLines = 2;
	title.text = @"PRICES (Including Tax)\nAll Amounts in US Dollars $";
	 
	[headerView addSubview:title];
	 
	return headerView;
}

/*------------------------------------------------------------------------------------*/

@end
