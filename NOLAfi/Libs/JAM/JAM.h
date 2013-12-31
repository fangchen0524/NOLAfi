/*------------------------------------------------------------------------------------*/
//
//  JAM.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#ifdef DEBUG
#define debug if(1)
#else
#define debug if(0)
#endif

/*------------------------------------------------------------------------------------*/
// Types
/*------------------------------------------------------------------------------------*/

typedef void (^JAMCompletionBlock)(void);
typedef void (^JAMCompletionBlockWithParam)(id a_param);
typedef void (^JAMCompletionBlockWithParam2)(id a_param1, id a_param2);

/*------------------------------------------------------------------------------------*/
// Defines
/*------------------------------------------------------------------------------------*/

#define kDefaultAnimationDuration 0.33

/*------------------------------------------------------------------------------------*/
// Macros
/*------------------------------------------------------------------------------------*/

#define isObjectNilOrNull(object) ((object == nil) || (((NSNull*)object) == [NSNull null]))
#define isNSStringEmptyOrNil(string) ((string == nil) || (((NSNull*)string) == [NSNull null]) || ([string length] <= 0) || ([[string lowercaseString] isEqualToString:@"<null>"]))
#define isCGRectZero(rect) (BOOL)(!((int)rect.origin.x | (int)rect.origin.y | (int)rect.size.width | (int)rect.size.height))
#define isCGPointZero(point) (BOOL)(!((int)point.x | (int)point.y))
#define isIPhone5 (BOOL)((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568))

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define STR_VALUE(string) #string

/*------------------------------------------------------------------------------------*/
// Associate Property Interface Macros
/*------------------------------------------------------------------------------------*/

#define ASSOCIATED_PROPERTY_INTERFACE(get, set, objectType)                                                         \
	@property (nonatomic, strong) IBOutlet objectType get;                                                          \

/*------------------------------------------------------------------------------------*/
// Associate Property Implementation
//      DEBUG - Will assert if the
/*------------------------------------------------------------------------------------*/

#if DEBUG
// Debug
#define ASSOCIATED_PROPERTY_IMPLEMENTATION_NSNUMBER(get, set, key)                                                  \
	static char const * const key = STR_VALUE(get);                                                                 \
	@dynamic get;                                                                                                   \
	- (NSNumber*)get                                                                                                \
	{                                                                                                               \
		return objc_getAssociatedObject(self, key);                                                                 \
	}                                                                                                               \
	- (void)set:(NSNumber*)get                                                                                      \
	{                                                                                                               \
		assert([get isKindOfClass:[NSNumber class]]);                                                               \
		objc_setAssociatedObject(self, key, get, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                \
	}                                                                                                               \

#else
// Release
#define ASSOCIATED_PROPERTY_IMPLEMENTATION_NSNUMBER(get, set, key)                                                  \
	static char const * const key = STR_VALUE(get);                                                                 \
	@dynamic get;                                                                                                   \
	- (NSNumber*)get                                                                                                \
	{                                                                                                               \
		return objc_getAssociatedObject(self, key);                                                                 \
	}                                                                                                               \
	- (void)set:(NSNumber*)get                                                                                      \
	{                                                                                                               \
		objc_setAssociatedObject(self, key, get, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                \
	}                                                                                                               \

#endif // #if DEBUG

#if DEBUG
// Debug
#define ASSOCIATED_PROPERTY_IMPLEMENTATION_NSVALUE(get, set, key)                                                   \
	static char const * const key = STR_VALUE(get);                                                                 \
	@dynamic get;                                                                                                   \
	- (NSValue*)get                                                                                                 \
	{                                                                                                               \
		return objc_getAssociatedObject(self, key);                                                                 \
	}                                                                                                               \
	- (void)set:(NSValue*)get                                                                                       \
	{                                                                                                               \
		assert([get isKindOfClass:[NSValue class]]);                                                                \
		objc_setAssociatedObject(self, key, get, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                \
	}                                                                                                               \

#else
// Release
#define ASSOCIATED_PROPERTY_IMPLEMENTATION_NSVALUE(get, set, key)                                                   \
	static char const * const key = STR_VALUE(get);                                                                 \
	@dynamic get;                                                                                                   \
	- (NSValue*)get                                                                                                 \
	{                                                                                                               \
		return objc_getAssociatedObject(self, key);                                                                 \
	}                                                                                                               \
	- (void)set:(NSValue*)get                                                                                       \
	{                                                                                                               \
		objc_setAssociatedObject(self, key, get, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                \
	}                                                                                                               \

#endif // #if DEBUG

#define ASSOCIATED_PROPERTY_IMPLEMENTATION_OBJECT(get, set, key)                                                    \
	static char const * const key = STR_VALUE(get);                                                                 \
	@dynamic get;                                                                                                   \
	- (id)get                                                                                                       \
	{                                                                                                               \
		return objc_getAssociatedObject(self, key);                                                                 \
	}                                                                                                               \
	- (void)set:(id)get                                                                                             \
	{                                                                                                               \
		objc_setAssociatedObject(self, key, get, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                \
	}                                                                                                               \

/*------------------------------------------------------------------------------------*/
