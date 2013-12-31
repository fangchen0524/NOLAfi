/*------------------------------------------------------------------------------------*/
//
//  UIView+Custom.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAM.h"

/*------------------------------------------------------------------------------------*/
// Interface
/*------------------------------------------------------------------------------------*/

@interface UIView (Custom)

/*------------------------------------------------------------------------------------*/
// Associated Properties (Dynamic ivars, injected into object that category is applied to)
/*------------------------------------------------------------------------------------*/

ASSOCIATED_PROPERTY_INTERFACE(customInitialCGRect, setCustomInitialCGRect, NSValue*);
ASSOCIATED_PROPERTY_INTERFACE(customInitialAutoresizingInteger, setCustomInitialAutoresizingInteger, NSNumber*);
ASSOCIATED_PROPERTY_INTERFACE(customInitialLayerPositionCGPoint, setCustomInitialLayerPositionCGPoint, NSValue*);
ASSOCIATED_PROPERTY_INTERFACE(customInitialLayerAnchorCGPoint, setCustomInitialLayerAnchorCGPoint, NSValue*);
ASSOCIATED_PROPERTY_INTERFACE(customIdentifierNSString, setCustomIdentifierNSString, NSString*);
ASSOCIATED_PROPERTY_INTERFACE(customNSDictionary, setCustomNSDictionary, NSDictionary*);

/*------------------------------------------------------------------------------------*/

@end
