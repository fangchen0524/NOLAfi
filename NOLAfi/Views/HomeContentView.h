/*------------------------------------------------------------------------------------*/
//
//  HomeContentView.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 5/2/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAMView.h"

/*------------------------------------------------------------------------------------*/

@class HomeViewController;

/*------------------------------------------------------------------------------------*/

@interface HomeContentView : JAMView

/*------------------------------------------------------------------------------------*/

@property (nonatomic, weak) HomeViewController * homeViewController;

@property (nonatomic, strong) UIView * interactionOverlay;

/*------------------------------------------------------------------------------------*/

@end
