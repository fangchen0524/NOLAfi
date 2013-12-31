/*------------------------------------------------------------------------------------*/
//
//  JAMHitView.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMHitView.h"

/*------------------------------------------------------------------------------------*/

@interface JAMHitView()
{
    NSMutableArray * _registeredHitTests;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation JAMHitView

/*------------------------------------------------------------------------------------*/
// Disable Warnings
/*------------------------------------------------------------------------------------*/

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

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

- (void)dealloc
{
    self.registeredHitDelegate =  nil;
	
    _registeredHitTests = nil;
}

/*------------------------------------------------------------------------------------*/

- (void)registerHitTest:(NSString*)a_hitTest
{
    if (!_registeredHitTests)
    {
        _registeredHitTests = [NSMutableArray array];
    }
    
    [_registeredHitTests addObject:a_hitTest];
}

/*------------------------------------------------------------------------------------*/

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    NSEnumerator * reverseE = [self.subviews reverseObjectEnumerator];
    UIView * iSubView = nil;
    while ((iSubView = [reverseE nextObject]))
	{
        UIView * viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if (viewWasHit)
		{
            BOOL ignore = NO;
            
            for (NSString * hitTest in _registeredHitTests)
            {
                SEL selector = NSSelectorFromString(hitTest);
                if ((selector) &&
                    ([self.registeredHitDelegate respondsToSelector:selector]))
                {
                    id rVal = [self.registeredHitDelegate performSelector:selector withObject:viewWasHit withObject:[NSValue valueWithCGPoint:point]];
                    if ((rVal) &&
                        ([rVal isKindOfClass:[NSNumber class]]) &&
                        ([(NSNumber*)rVal boolValue]))
                    {
                        ignore = YES;
                        break;
                    }
                }
            }

            if (ignore)
            {
#if DEBUG_JAMHITVIEW
                debug NSLog(@">> JAMHitView::hitTest: [IGNORED] %@ @ (%f, %f) <<", [viewWasHit description], point.x, point.y);
#endif // #if DEBUG_JAMHITVIEW
                continue;
            }
            
#if DEBUG_JAMHITVIEW
            debug NSLog(@">> JAMHitView::hitTest: [ATE] %@ @ (%f, %f) <<", [viewWasHit description], point.x, point.y);
#endif // #if DEBUG_JAMHITVIEW
            
            return viewWasHit;
        }
    }
	
    return [super hitTest:point withEvent:event];
}

/*------------------------------------------------------------------------------------*/

@end