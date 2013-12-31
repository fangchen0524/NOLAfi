/*------------------------------------------------------------------------------------*/
//
//  UIView+Custom.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "UIView+Custom.h"

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation UIView (Custom)

/*------------------------------------------------------------------------------------*/
// Associated Properties (Dynamic ivars, injected into object that category is applied to)
/*------------------------------------------------------------------------------------*/

ASSOCIATED_PROPERTY_IMPLEMENTATION_NSVALUE(customInitialCGRect, setCustomInitialCGRect, CustomInitialCGRectObjKey);
ASSOCIATED_PROPERTY_IMPLEMENTATION_NSNUMBER(customInitialAutoresizingInteger, setCustomInitialAutoresizingInteger, CustomInitialAutoresizingIntegerObjKey);
ASSOCIATED_PROPERTY_IMPLEMENTATION_NSVALUE(customInitialLayerPositionCGPoint, setCustomInitialLayerPositionCGPoint, CustomInitialLayerPositionCGPointObjKey);
ASSOCIATED_PROPERTY_IMPLEMENTATION_NSVALUE(customInitialLayerAnchorCGPoint, setCustomInitialLayerAnchorCGPoint, CustomInitialLayerAnchorCGPointObjKey);
ASSOCIATED_PROPERTY_IMPLEMENTATION_OBJECT(customIdentifierNSString, setCustomIdentifierNSString, CustomIdentifierNSStringObjKey);
ASSOCIATED_PROPERTY_IMPLEMENTATION_OBJECT(customNSDictionary, setCustomNSDictionary, CustomNSDictionaryObjKey);

/*------------------------------------------------------------------------------------*/

@end
