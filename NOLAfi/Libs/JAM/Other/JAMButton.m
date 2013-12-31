/*------------------------------------------------------------------------------------*/
//
//  JAMButton.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMButton.h"
#import "JAMBitmap.h"
	
/*------------------------------------------------------------------------------------*/

@implementation JAMButton

/*------------------------------------------------------------------------------------*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        // Initialization code
    }
    
    return self;
}

/*------------------------------------------------------------------------------------*/

- (void)setupHighlightWithColorAndAlpha:(UIColor*)a_color alpha:(CGFloat)a_alpha
{
    CGRect frame = self.frame;
    CGSize size = frame.size;
    
    UIImageView * overlayImageView = [[UIImageView alloc] initWithFrame:frame];
    JAMBitmap * bitmap = [[JAMBitmap alloc] initWithSize:size];
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = a_alpha;
    [a_color getRed:&red green:&green blue:&blue alpha:&alpha];
    [bitmap clear:BITMAPCOLOR((red * 255.0), (green * 255.0), (blue * 255.0), (alpha * 255.0))];
    [bitmap blitToImageView:overlayImageView];
    [self setImage:overlayImageView.image forState:UIControlStateHighlighted];
}

/*------------------------------------------------------------------------------------*/
 
@end
