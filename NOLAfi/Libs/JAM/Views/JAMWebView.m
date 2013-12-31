/*------------------------------------------------------------------------------------*/
//
//  JAMWebView.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMWebView.h"

/*------------------------------------------------------------------------------------*/
// Private Interface
/*------------------------------------------------------------------------------------*/

@interface JAMWebView()

@end

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation JAMWebView

/*------------------------------------------------------------------------------------*/
// Disable Warnings
/*------------------------------------------------------------------------------------*/

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

/*------------------------------------------------------------------------------------*/

- (id)init
{
    self = [super init];
    
    if (self)
    {
#if !DEBUG
        self.debugLogging = NO;
        self.debugJavascript = NO;
        self.debugTestHtmlLoaded = NO;
#endif // #if DEBUG
    }
    
    return self;
}

/*------------------------------------------------------------------------------------*/

- (void)loadRequestedUrl:(NSString*)a_urlName
{
    self.hostURL = a_urlName;

    if (self.debugJavascript)
    {
        if (self.debugTestHtmlLoaded)
        {
            // load our html file
            self.hostURL = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] pathForResource:@"webview-document" ofType:@"html"]];
            NSURL * url = [NSURL fileURLWithPath:self.hostURL];
            [self loadRequest:[NSURLRequest requestWithURL:url]];
            self.debugTestHtmlLoaded = YES;
            return;
        }
    }
    else
    {
        NSRange range = [a_urlName rangeOfString:@"http"];
        if (range.location == NSNotFound)
        {
            self.hostURL = [NSString stringWithFormat:@"http://%@", a_urlName];
        }
    }
    
    NSURL * url = [NSURL URLWithString:self.hostURL];
    if (url)
    {
        if (self.debugLogging)
        {
            debug NSLog(@">> [JAMWebView::loadRequestedUrl] %@ <<", url);
        }
        
        if (self.isLoading)
        {
            [self stopLoading];
        }
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self loadRequest:request];
    }
}

/*------------------------------------------------------------------------------------*/

- (void)loadRequestedUrlWithActivityIndicator:(NSString*)a_urlName
{
	self.delegate = self;
		
	[self loadRequestedUrl:a_urlName];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - UIWebViewDelegate
/*------------------------------------------------------------------------------------*/

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[[AppDelegate sharedDelegate] showBusyView];
}

/*------------------------------------------------------------------------------------*/

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[AppDelegate sharedDelegate] hideBusyView];
}

/*------------------------------------------------------------------------------------*/

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[[AppDelegate sharedDelegate] hideBusyView];
}

/*------------------------------------------------------------------------------------*/
// JavaScript Methods
/*------------------------------------------------------------------------------------*/

- (BOOL)jsShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.debugLogging)
    {
        debug NSLog(@">> [JAMWebView::jsShouldStartLoadWithRequest] request=%@ <<", request);
    }
    
	NSString * requestString = [[request URL] absoluteString];
    
    if ([requestString hasPrefix:@"js-frame"])
    {
        NSArray * components = [requestString componentsSeparatedByString:@":"];
        
        if ([components count] >= 4)
        {
            NSString * function = (NSString*)[components objectAtIndex:1];
            int callbackId = [((NSString*)[components objectAtIndex:2]) intValue];
            NSString * argsAsString = [(NSString*)[components objectAtIndex:3] 
                                       stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            SBJsonParser * parser = [[SBJsonParser alloc] init];
            NSArray * args = (NSArray*)[parser objectWithString:argsAsString];
            
            [self jsHandleCall:function callbackId:callbackId args:args];
            
            return NO;
        }
    }
    
    return YES;
}

/*------------------------------------------------------------------------------------*/

// Call this function when you have results to send back to javascript callbacks
// callbackId : int comes from handleCall function
// args: list of objects to send to the javascript callback
- (void)jsReturnResult:(int)callbackId args:(id)arg, ...;
{
    if (self.debugLogging)
    {
        debug NSLog(@">> [JAMWebView::jsReturnResult] callbackId=%i args=%@ <<", callbackId, arg);
    }
    
    if (callbackId == 0)
    {
        return;
    }
    
    va_list argsList;
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    
    if (arg != nil)
    {
        [resultArray addObject:arg];
        va_start(argsList, arg);
        while((arg = va_arg(argsList, id)) != nil)
        {
            [resultArray addObject:arg];
        }
        va_end(argsList);
    }
    
    SBJsonWriter * writer = [[SBJsonWriter alloc] init];
    NSString * resultArrayString = [writer stringWithObject:resultArray];
    
    // We need to perform selector with afterDelay 0 in order to avoid weird recursion stop
    // when calling NativeBridge in a recursion more then 200 times :s (fails ont 201th calls!!!)
    [self performSelector:@selector(jsReturnResultAfterDelay:) withObject:[NSString stringWithFormat:@"NativeBridge.resultForCallback(%d,%@);",callbackId,resultArrayString] afterDelay:0];
}

/*------------------------------------------------------------------------------------*/

-(void)jsReturnResultAfterDelay:(NSString*)str 
{
    if (self.debugLogging)
    {
        debug NSLog(@">> [JAMWebView::jsReturnResultAfterDelay] str=%@ <<", str);
    }
    
    // Now perform this selector with waitUntilDone:NO in order to get a huge speed boost! (about 3x faster on simulator!!!)
    [self performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:str waitUntilDone:NO];
}

/*------------------------------------------------------------------------------------*/

// Implements all your native functions, by matching 'functionName' and parsing 'args'
// Use 'callbackId' with 'returnResult' selector when you get some results to send back to javascript
- (void)jsHandleCall:(NSString*)functionName callbackId:(int)callbackId args:(NSArray*)args
{
    if (self.debugLogging)
    {
        debug NSLog(@">> [JAMWebView::jsHandleCall] callbackId=%i functionName=%@ args=%@ <<", callbackId, functionName, args);
    }

    // Handle function, if valid
    BOOL found = NO;
    for (NSDictionary * dict in self.jsNativeMethods)
    {
        // Is this a valid functionName?
        if ((!isNSStringEmptyOrNil(functionName)) &&
            ([functionName isEqualToString:[dict objectForKey:@"kJavaScriptMethod"]]))
        {
            // Verify call arguments
            if ([args count] != [[dict objectForKey:@"kJavaScriptArgTypes"] count])
            {
                if (self.debugLogging)
                {
                    debug NSLog(@">> [JAMWebView::jsHandleCall] '%@' requires '%i' arguments! <<", [dict objectForKey:@"kJavaScriptMethod"], [[dict objectForKey:@"kJavaScriptArgCount"] intValue]);
                }
                return;
            }
            
            // Call selector
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:callbackId:", [dict objectForKey:[NSString stringWithFormat:@"kJavaScriptMethod"]]]);
            if ([self.jsNativeDelegate respondsToSelector:selector])
            {
                [self.jsNativeDelegate performSelector:selector withObject:args withObject:[NSNumber numberWithInt:callbackId]];
                found = YES;
                break;
            }
            if (self.debugLogging)
            {
                debug NSLog(@">> [JAMWebView::jsHandleCall] delegate '%@' does respond to selector '%@'! <<", [self.jsNativeDelegate description], NSStringFromSelector(selector));
            }
        } 
    }
    
    if (!found)
    {
        if (self.debugLogging)
        {
            debug NSLog(@">> [JAMWebView::jsHandleCall] Unimplemented JavaScript method '%@' <<", functionName);
        }
    }
}

/*------------------------------------------------------------------------------------*/

@end
