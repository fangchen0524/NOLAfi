/*------------------------------------------------------------------------------------*/
//
//  JAMBitmap.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMBitmap.h"

/*------------------------------------------------------------------------------------*/

void createBitmapContext(CGSize size, 
						 CGContextRef * context,
						 int * pixelsWide,
						 int * pixelsHigh,
						 int * bytesPerRow,
						 int * byteCount);

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation JAMBitmap

/*------------------------------------------------------------------------------------*/

- (id)initWithSize:(CGSize)a_size
{
	self = [super init];
	
	if (self)
	{
		createBitmapContext(a_size, &_context, &_pixelsWide, &_pixelsHigh, &_bytesPerRow, &_byteCount);
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (void)clear:(int)a_color
{
	if (self.context)
	{
		void * data = CGBitmapContextGetData(self.context);
		if (data)
		{
			int * dwordData = (int*)data;
			for (int y = (self.pixelsHigh - 1); y >= 0; y--)
			{					
				int offset = (y * self.pixelsWide);
				for (int x = 0; x < self.pixelsWide; x++)
				{
					*(dwordData + offset + x) = a_color;
				}
			}
		}
	}
}

/*------------------------------------------------------------------------------------*/

- (void)blitToImageView:(UIImageView*)a_imageView
{
	CGImageRef cgImage = CGBitmapContextCreateImage(self.context);
	[a_imageView setImage:[UIImage imageWithCGImage:cgImage]];
	CGImageRelease(cgImage);
}

/*------------------------------------------------------------------------------------*/

- (void)getContextImage:(UIImage**)a_image
{
	CGImageRef cgImage = CGBitmapContextCreateImage(self.context);
    *a_image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
}

/*------------------------------------------------------------------------------------*/

@end

/*------------------------------------------------------------------------------------*/

void createBitmapContext(CGSize size, 
						 CGContextRef * context,
						 int * pixelsWide,
						 int * pixelsHigh,
						 int * bytesPerRow,
						 int * byteCount)
						 
{
	*pixelsWide = size.width;
	*pixelsHigh = size.height;
    *bytesPerRow = ((*pixelsWide) * 4); //4
	*byteCount = ((*bytesPerRow) * (*pixelsHigh));
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	*context = CGBitmapContextCreate(NULL, //bitmapData,
									 (*pixelsWide),
									 (*pixelsHigh),
									 8,      // bits per component
									 (*bytesPerRow),
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	CGColorSpaceRelease(colorSpace);
}

/*------------------------------------------------------------------------------------*/
