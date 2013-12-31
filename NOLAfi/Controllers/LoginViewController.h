/*------------------------------------------------------------------------------------*/
//
//  LoginViewController.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAMViewController.h"

/*------------------------------------------------------------------------------------*/

@interface LoginViewController : JAMViewController

/*------------------------------------------------------------------------------------*/

typedef enum
{
	kLoginTypeUnknown = 0,
	kLoginTypeNawlin,
	kLoginTypeFacebook,
} LoginType;

/*------------------------------------------------------------------------------------*/

@property (nonatomic, assign) LoginType loginType;

/*------------------------------------------------------------------------------------*/

@end
