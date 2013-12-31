/*------------------------------------------------------------------------------------*/
//
//  AccountViewController.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 1/20/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMViewController.h"

/*------------------------------------------------------------------------------------*/
#pragma mark - Interface
/*------------------------------------------------------------------------------------*/

@interface AccountViewController : JAMViewController

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UIImageView * pictureImageView;

@property (nonatomic, assign) BOOL displayInfo;
@property (nonatomic, assign) BOOL newLogin;

/*------------------------------------------------------------------------------------*/

@end
