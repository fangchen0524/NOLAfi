/*------------------------------------------------------------------------------------*/
//
//  FavoritesTableViewCell.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/16/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

@interface FavoritesTableViewCell : UITableViewCell

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UILabel * favoriteTitle;
@property (nonatomic, strong) IBOutlet UIImageView * favoriteImageView;

/*------------------------------------------------------------------------------------*/

@end
