/*------------------------------------------------------------------------------------*/
//
//  JAMBusyView.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAMView.h"

/*------------------------------------------------------------------------------------*/
// Interface
/*------------------------------------------------------------------------------------*/

@interface JAMBusyView : JAMView

/*------------------------------------------------------------------------------------*/
// Properties
/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UIView * backgroundView;
@property (nonatomic, strong) IBOutlet UIView * activityView;
@property (nonatomic, strong) IBOutlet UIImageView * activityBackgroundImageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic, strong) IBOutlet UILabel * activityLabel;

@property (nonatomic, assign) CGFloat fadeToAlpha;

/*------------------------------------------------------------------------------------*/
// Instance Methods
/*------------------------------------------------------------------------------------*/

- (void)activityStart;
- (void)activityStop;
- (BOOL)isShowing;

/*------------------------------------------------------------------------------------*/

@end
