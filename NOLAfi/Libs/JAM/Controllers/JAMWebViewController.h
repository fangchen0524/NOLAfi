/*------------------------------------------------------------------------------------*/
//
//  JAMWebViewController.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAMWebView.h"

/*------------------------------------------------------------------------------------*/

@interface JAMWebViewController : UIViewController

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet JAMWebView * webView;
@property (nonatomic, strong) IBOutlet UIView * header;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/*------------------------------------------------------------------------------------*/

- (id)initWithNibNameAndHeader:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil header:(UIView*)a_header;

/*------------------------------------------------------------------------------------*/

@end
