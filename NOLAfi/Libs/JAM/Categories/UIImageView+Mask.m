/*------------------------------------------------------------------------------------*/
//
//  UIImageView+Mask.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "UIImageView+Mask.h"

/*------------------------------------------------------------------------------------*/

@implementation UIImageView (Mask)

/*------------------------------------------------------------------------------------*/

+ (void)applyMaskWithImageAndSize:(UIImageView*)a_imageView maskImage:(UIImage*)a_maskImage size:(CGSize)a_size
{
	CALayer * mask = [CALayer layer];
	mask.contents = (id)[a_maskImage CGImage];
	mask.frame = CGRectMake(0, 0, a_size.width, a_size.height);
	a_imageView.layer.mask = mask;
	a_imageView.layer.masksToBounds = YES;
}

/*------------------------------------------------------------------------------------*/

- (void)applyMaskWithImageAndSize:(UIImage*)a_maskImage size:(CGSize)a_size
{
	[UIImageView applyMaskWithImageAndSize:self maskImage:a_maskImage size:a_size];
}

/*------------------------------------------------------------------------------------*/

@end
