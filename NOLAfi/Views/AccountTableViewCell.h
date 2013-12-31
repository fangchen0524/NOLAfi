/*------------------------------------------------------------------------------------*/
//
//  AccountTableViewCell.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/16/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAMTableViewCell.h"

/*------------------------------------------------------------------------------------*/

@interface AccountTableViewCell : JAMTableViewCell

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UIImageView * accountImageView;
@property (nonatomic, strong) IBOutlet UILabel * accountNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView * facebookImageView;

/*------------------------------------------------------------------------------------*/

@end
