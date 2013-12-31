/*------------------------------------------------------------------------------------*/
//
//  JAMBitmap.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

#define BITMAPCOLOR(r, g, b, a) (int)(((int)a) + (((int)r) << 8) + (((int)g) << 16) + (((int)b) << 24))

/*------------------------------------------------------------------------------------*/
// Interface
/*------------------------------------------------------------------------------------*/

@interface JAMBitmap : NSObject

/*------------------------------------------------------------------------------------*/
// Properties
/*------------------------------------------------------------------------------------*/

@property (nonatomic, assign, readonly) CGContextRef context;
@property (nonatomic, assign, readonly) int pixelsWide;
@property (nonatomic, assign, readonly) int pixelsHigh;
@property (nonatomic, assign, readonly) int bytesPerRow;
@property (nonatomic, assign, readonly) int byteCount;

/*------------------------------------------------------------------------------------*/
// Instance Methods
/*------------------------------------------------------------------------------------*/

- (id)initWithSize:(CGSize)a_size;
- (void)clear:(int)color;
- (void)blitToImageView:(UIImageView*)a_imageView;
- (void)getContextImage:(UIImage**)a_image;

/*------------------------------------------------------------------------------------*/

@end
