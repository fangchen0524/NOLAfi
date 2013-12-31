/*------------------------------------------------------------------------------------*/
//
//  WebControllerHeaderView.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/21/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

@interface WebControllerHeaderView : UIView

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UIButton * backButton;
@property (nonatomic, strong) IBOutlet UIImageView * titleImageView;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;

/*------------------------------------------------------------------------------------*/

@end
