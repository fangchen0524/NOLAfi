/*------------------------------------------------------------------------------------*/
//
//  JAMWebView.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAM.h"
#import "SBJson.h"

/*------------------------------------------------------------------------------------*/
// Interface
/*------------------------------------------------------------------------------------*/

@interface JAMWebView : UIWebView <UIWebViewDelegate>

/*------------------------------------------------------------------------------------*/
// Properties
/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) NSString * hostURL;
@property (nonatomic, strong) NSMutableArray * jsNativeMethods;

@property (nonatomic, weak) id jsNativeDelegate;

@property (nonatomic, assign) BOOL debugLogging;
@property (nonatomic, assign) BOOL debugJavascript;
@property (nonatomic, assign) BOOL debugTestHtmlLoaded;

/*------------------------------------------------------------------------------------*/
// Instance Methods
/*------------------------------------------------------------------------------------*/

- (void)loadRequestedUrl:(NSString*)a_urlName;
- (void)loadRequestedUrlWithActivityIndicator:(NSString*)a_urlName;

// Javascript Methods
- (BOOL)jsShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)jsReturnResult:(int)callbackId args:(id)arg, ...;
- (void)jsHandleCall:(NSString*)functionName callbackId:(int)callbackId args:(NSArray*)args;

/*------------------------------------------------------------------------------------*/

@end
