/*------------------------------------------------------------------------------------*/
//
//  UIImage+ImmediateLoad.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "UIImage+ImmediateLoad.h"

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation UIImage (ImmediateLoad)

/*------------------------------------------------------------------------------------*/
// Class Methods
/*------------------------------------------------------------------------------------*/

+ (UIImage*)immediateLoadWithContentsOfFile:(NSString*)path 
{
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:path];
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imageRef = [image CGImage];
    CGRect rect = CGRectMake(0.f, 0.f, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       8, //CGImageGetBitsPerComponent(imageRef),
                                                       CGImageGetBytesPerRow(imageRef),
                                                       colorSpace, //CGImageGetColorSpace(imageRef),
                                                       kCGImageAlphaPremultipliedFirst //CGImageGetBitmapInfo(imageRef)
                                                       );
    CGContextDrawImage(bitmapContext, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage * decompressedImage = [UIImage imageWithCGImage:decompressedImageRef];
    CGImageRelease(decompressedImageRef);
    CGContextRelease(bitmapContext);
    
    return decompressedImage;
}

/*------------------------------------------------------------------------------------*/

@end
