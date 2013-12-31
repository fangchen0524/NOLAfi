/*------------------------------------------------------------------------------------*/
//
//  EventTableViewCell.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/19/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

@interface EventTableViewCell : UITableViewCell

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UILabel * timeLabel;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UILabel * infoLabel;
@property (nonatomic, strong) IBOutlet UILabel * venueTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel * venueAddressLabel;
@property (nonatomic, strong) IBOutlet UILabel * dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView * pictureImageView;

@property (nonatomic, strong) UIViewController * parentViewController;

@property (nonatomic, weak) NSDictionary * eventDict;

/*------------------------------------------------------------------------------------*/

@end
