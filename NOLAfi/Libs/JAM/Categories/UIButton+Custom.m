/*------------------------------------------------------------------------------------*/
//
//  UIButton+Custom.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "UIButton+Custom.h"

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation UIButton (Custom)

/*------------------------------------------------------------------------------------*/
// Associated Properties (Dynamic ivars, injected into object that category is applied to)
/*------------------------------------------------------------------------------------*/

ASSOCIATED_PROPERTY_IMPLEMENTATION_NSVALUE(customInitialCGRect, setCustomInitialCGRect, CustomInitialCGRectObjKey);
ASSOCIATED_PROPERTY_IMPLEMENTATION_OBJECT(customNSDictionary, setCustomNSDictionary, CustomNSDictionaryObjKey);

/*------------------------------------------------------------------------------------*/

@end
