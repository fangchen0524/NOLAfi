/*------------------------------------------------------------------------------------*/
//
//  JAMHitView.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

@interface JAMHitView : UIView

/*------------------------------------------------------------------------------------*/

@property (nonatomic, weak) id registeredHitDelegate;

/*------------------------------------------------------------------------------------*/

- (void)registerHitTest:(NSString*)a_hitTest;

/*------------------------------------------------------------------------------------*/
// Example Register Hit Test Callback
//
// Return value should specify whether to ignore hit or not
//      YES = Ignore
//      NO = Use the hit
//
/*------------------------------------------------------------------------------------*

- (NSNumber*)scrollViewHitTest:(UIView*)a_hitView point:(NSValue*)a_valuePoint
{
    if ((a_hitView) &&
        (a_valuePoint) &&
        ([a_hitView isKindOfClass:[UIScrollView class]]))
    {
        CGPoint point = [a_valuePoint CGPointValue];
        UIScrollView * scrollView = (UIScrollView*)a_hitView;
        if ((point.x > (scrollView.contentOffset.x + 436) &&
             (point.x < 436)))
        {
            return [NSNumber numberWithBool:YES];
        }
        else if ((scrollView.contentOffset.x > 1830) &&
                 (point.x > self.view.frame.size.width - 436))
        {
            return [NSNumber numberWithBool:YES];
        }
    }
    
    return [NSNumber numberWithBool:NO];
}

/*------------------------------------------------------------------------------------*/

@end
