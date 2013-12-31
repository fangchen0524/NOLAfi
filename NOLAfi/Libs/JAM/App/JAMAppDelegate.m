/*------------------------------------------------------------------------------------*/
//
//  JAMAppDelegate.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMAppDelegate.h"

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation JAMAppDelegate

/*------------------------------------------------------------------------------------*/
// Static Functions
/*------------------------------------------------------------------------------------*/

static void applicationExceptionHandler(NSException *exception)
{
	debug NSLog(@">> JAMAppDelegate Exception: name:%@ reason:%@ <<", [exception name], [exception reason]);
    debug NSLog(@">> JAMAppDelegate Stack Trace: %@ <<", [[exception callStackSymbols] description]);
}

/*------------------------------------------------------------------------------------*/
// Delegate/Class Overrides
/*------------------------------------------------------------------------------------*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set exception handler
    NSSetUncaughtExceptionHandler(&applicationExceptionHandler);

    // Allocate window
	if (!self.window)
	{
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	}

    return YES;
}

/*------------------------------------------------------------------------------------*/
// Shared Delegate
/*------------------------------------------------------------------------------------*/

+ (id)sharedDelegate
{
	return [[UIApplication sharedApplication] delegate];
}

/*------------------------------------------------------------------------------------*/
// Sound
/*------------------------------------------------------------------------------------*/

+ (void)playSound:(NSString*)a_fName ext:(NSString*)a_ext
{
    SystemSoundID audioEffect;
    NSString *path  = [[NSBundle mainBundle] pathForResource:a_fName ofType:a_ext];
    CFURLRef baseURL = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID(baseURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
}

/*------------------------------------------------------------------------------------*/
// Resources
/*------------------------------------------------------------------------------------*/

+ (NSString*)obtainResourcePath:(NSString*)a_fileName ofType:(NSString*)a_ofType searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite
{
    NSString * resourcePath = nil;
	
    if ((!isNSStringEmptyOrNil(a_fileName)) &&
		(!isNSStringEmptyOrNil(a_ofType)))
    {
		NSString * searchPath = [NSSearchPathForDirectoriesInDomains(a_searchPathDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		if (!isNSStringEmptyOrNil(a_destinationPath))
		{
			resourcePath = [NSString stringWithFormat:@"%@/%@/%@.%@", searchPath, a_destinationPath, a_fileName, a_ofType];
			
			NSError * error = nil;
			[[NSFileManager defaultManager] createDirectoryAtPath:[resourcePath stringByDeletingLastPathComponent]
									  withIntermediateDirectories:YES
													   attributes:nil
															error:&error];
		}
		else
		{
			resourcePath = [NSString stringWithFormat:@"%@/%@.%@", searchPath, a_fileName, a_ofType];
		}
	
		if ((![[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) ||
			(a_overWrite))
		{
			NSError * error = nil;
			
			NSString * resourceBundlePath = [[NSBundle mainBundle] pathForResource:a_fileName ofType:a_ofType];
			if (!isNSStringEmptyOrNil(resourceBundlePath))
			{
				if (a_overWrite)
				{
					[[NSFileManager defaultManager] removeItemAtPath:resourcePath error:&error];
				}
				
				if (![[NSFileManager defaultManager] copyItemAtPath:resourceBundlePath toPath:resourcePath error:&error])
				{
//					debug NSLog(@">> JAMAppDelegate::obtainResourcePath: Unable to copy '%@' to '%@' (%@).", resourcePath, resourceBundlePath, [error localizedDescription]);
					return nil;
				}
				else
				{
//					debug NSLog(@">> JAMAppDelegate::obtainResourcePath: Copied '%@' to '%@'.", resourceBundlePath, resourcePath);
				}
			}
			else
			{
//				debug NSLog(@">> JAMAppDelegate::obtainResourcePath: '%@.%@' is not in the bundle.", a_fileName, a_ofType);
			}
		}
	}
    
    return resourcePath;
}

/*------------------------------------------------------------------------------------*/

+ (NSString*)saveResource:(NSString*)a_fileName ofType:(NSString*)a_ofType data:(id)a_data searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite
{
    NSString * resourcePath = nil;
    
    if ((!isNSStringEmptyOrNil(a_fileName)) &&
		(!isNSStringEmptyOrNil(a_ofType)))
    {
        NSString * searchPath = [NSSearchPathForDirectoriesInDomains(a_searchPathDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
        if (!isNSStringEmptyOrNil(a_destinationPath))
        {
            resourcePath = [NSString stringWithFormat:@"%@/%@/%@.%@", searchPath, a_destinationPath, a_fileName, a_ofType];
            
            NSError * error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:[resourcePath stringByDeletingLastPathComponent]
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        else
        {
            resourcePath = [NSString stringWithFormat:@"%@/%@.%@", searchPath, a_fileName, a_ofType];
        }
        
        NSError * error = nil;
        if (a_overWrite)
        {
            [[NSFileManager defaultManager] removeItemAtPath:resourcePath error:&error];
        }
        
        BOOL result = NO;
        if ([a_data respondsToSelector:@selector(writeToFile:atomically:)])
        {
            result = [a_data writeToFile:resourcePath atomically:YES];
        }
        if (!result)
        {
            debug NSLog(@">> JAMAppDelegate::saveResource: Unable to writeToFile: %@.", resourcePath);
        }
        else
        {
//            debug NSLog(@">> JAMAppDelegate::saveResource: '%@' Successful.", resourcePath);
        }
    }
	
    return resourcePath;
}

/*------------------------------------------------------------------------------------*/
// pList
/*------------------------------------------------------------------------------------*/

+ (NSMutableDictionary*)loadPlistDictionary:(NSString*)a_fileName searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite
{
    return [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:
                                                             [JAMAppDelegate obtainResourcePath:a_fileName
																						 ofType:@"plist"
																			searchPathDirectory:a_searchPathDirectory
																				destinationPath:a_destinationPath
																					  overWrite:a_overWrite]]];
}

/*------------------------------------------------------------------------------------*/

+ (NSMutableArray*)loadPlistArray:(NSString*)a_fileName searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite
{
    return [NSMutableArray arrayWithContentsOfURL:[NSURL fileURLWithPath:
                                                   [JAMAppDelegate obtainResourcePath:a_fileName
																			   ofType:@"plist"
																  searchPathDirectory:a_searchPathDirectory
																	  destinationPath:a_destinationPath
																			overWrite:a_overWrite]]];
}

/*------------------------------------------------------------------------------------*/

+ (BOOL)savePlist:(NSMutableDictionary*)a_data fileName:(NSString*)a_fileName searchPathDirectory:(NSSearchPathDirectory)a_searchPathDirectory destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overWrite
{
    return (BOOL)[JAMAppDelegate saveResource:a_fileName
									   ofType:@"plist"
										 data:a_data
						  searchPathDirectory:a_searchPathDirectory
							  destinationPath:a_destinationPath
									overWrite:a_overWrite];
}

/*------------------------------------------------------------------------------------*/
// Bundles
/*------------------------------------------------------------------------------------*/

+ (NSBundle*)loadBundle:(NSString*)a_bundleName
{
    NSBundle * bundle = nil;
    NSURL * url = nil;
	if (!isNSStringEmptyOrNil(a_bundleName))
	{
		url = [[NSBundle mainBundle] URLForResource:a_bundleName withExtension:@"bundle"];
	}
	
    if (!url)
    {
        bundle = [NSBundle mainBundle];
    }
    else
    {
        bundle = [NSBundle bundleWithURL:url];
    }
    
    return bundle;
}

/*------------------------------------------------------------------------------------*/

+ (BOOL)resourceInBundle:(NSString*)a_fileName ofType:(NSString*)a_ofType bundleName:(NSString*)a_bundleName
{
	NSBundle * bundle = [JAMAppDelegate loadBundle:a_bundleName];
	if (bundle)
	{
		NSString * resourcePath = [bundle pathForResource:a_fileName ofType:a_ofType];
		if (!isNSStringEmptyOrNil(resourcePath))
		{
			return YES;
		}
	}
	
	return NO;
}

/*------------------------------------------------------------------------------------*/
// URL Commands
/*------------------------------------------------------------------------------------*/

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleURLCmd:url];
}

/*------------------------------------------------------------------------------------*/

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleURLCmd:url];
}

/*------------------------------------------------------------------------------------*/

- (BOOL)handleURLCmd:(NSURL*)a_url
{
    return NO;
}

/*------------------------------------------------------------------------------------*/
// Busy
/*------------------------------------------------------------------------------------*/

- (BOOL)displayBusyView
{
	if (!_busyView)
	{
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JAMBusyView" owner:nil options:nil];
		_busyView = (JAMBusyView*)[nib objectAtIndex:0];
		_busyView.hidden = NO;
	}
	
	CGRect windowRect = self.window.bounds;
	_busyView.frame = windowRect;
	
	BOOL found = NO;
	for (UIView * subView in self.window.subviews)
	{
		if (subView == _busyView)
		{
			found = YES;
			break;
		}
	}
	
	if (!found)
	{
		[self.window addSubview:_busyView];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.window bringSubviewToFront:_busyView];
			self.window.userInteractionEnabled = NO;
			_busyView.backgroundView.alpha = 0.0;
			[UIView animateWithDuration:0.33
							 animations:^{
								 _busyView.backgroundView.alpha = _busyView.fadeToAlpha;
							 }
			 ];
		});
		
		[_busyView activityStart];
		
		return YES;
	}
	
	return NO;
}

/*------------------------------------------------------------------------------------*/

- (BOOL)showBusyView
{
	_busyView.activityLabel.hidden = YES;
	
	return [self displayBusyView];
}

/*------------------------------------------------------------------------------------*/

- (BOOL)showBusyViewWithText:(NSString*)a_text
{
	_busyView.activityLabel.hidden = NO;
	_busyView.activityLabel.text = a_text;

	return [self displayBusyView];
}

/*------------------------------------------------------------------------------------*/

- (void)hideBusyView
{
	dispatch_async(dispatch_get_main_queue(), ^{
		_busyView.backgroundView.alpha = _busyView.fadeToAlpha;
		[UIView animateWithDuration:0.33
						 animations:^{
							 _busyView.backgroundView.alpha = 0.0;
						 }
						 completion:^(BOOL finished){
							 [_busyView activityStop];
							 [_busyView removeFromSuperview];
							 self.window.userInteractionEnabled = YES;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/
// Images
/*------------------------------------------------------------------------------------*/

+ (UIImage*)resizeImage:(UIImage*)a_image newSize:(CGSize)a_newSize
{
	UIGraphicsBeginImageContext(a_newSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	[a_image drawInRect:CGRectMake(0, 0, a_newSize.width, a_newSize.height)];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

/*------------------------------------------------------------------------------------*/
// Maps
/*------------------------------------------------------------------------------------*/

+ (void)animateMapToLocation:(MKMapView*)a_mapView location:(CLLocationCoordinate2D)a_location
{
    MKCoordinateRegion region;
    region.center = a_location;
    MKCoordinateSpan span = { 0.02, 0.02 };
    region.span = span;
    [a_mapView setRegion:region animated:YES];
}

/*------------------------------------------------------------------------------------*/

@end
