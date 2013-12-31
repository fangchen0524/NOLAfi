/*------------------------------------------------------------------------------------*/
//
//  UIImageView+Mask.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

@interface UIImageView (Mask)

/*------------------------------------------------------------------------------------*/

+ (void)applyMaskWithImageAndSize:(UIImageView*)a_imageView maskImage:(UIImage*)a_maskImage size:(CGSize)a_size;

/*------------------------------------------------------------------------------------*/

- (void)applyMaskWithImageAndSize:(UIImage*)a_maskImage size:(CGSize)a_size;

/*------------------------------------------------------------------------------------*/

@end
