/*------------------------------------------------------------------------------------*/
//
//  TestImageViewController.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/8/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

@interface TestImageViewController : UIViewController

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UIImageView * imageView;

/*------------------------------------------------------------------------------------*/

- (void)requestImage:(NSString*)a_imageUrlPath;

/*------------------------------------------------------------------------------------*/

@end
