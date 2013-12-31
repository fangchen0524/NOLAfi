/*------------------------------------------------------------------------------------*/
//
//  NSData+Save.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "NSData+Save.h"
#import "JAMAppDelegate.h"

/*------------------------------------------------------------------------------------*/

@implementation NSData (Save)

/*------------------------------------------------------------------------------------*/

+ (UIImage*)saveAsImage:(NSData*)a_data fileName:(NSString*)a_fileName destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overwrite
{
	NSString * file = [a_fileName stringByDeletingPathExtension];
	NSString * ext = [a_fileName pathExtension];
	
	// Save image
	[JAMAppDelegate saveResource:file
						  ofType:ext
							data:a_data
			 searchPathDirectory:NSDocumentDirectory
				 destinationPath:a_destinationPath
					   overWrite:a_overwrite];
	
	return [UIImage imageWithData:a_data];
}

/*------------------------------------------------------------------------------------*/

- (UIImage*)saveAsImage:(NSString*)a_fileName destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overwrite
{
	return [NSData saveAsImage:self fileName:a_fileName destinationPath:a_destinationPath overWrite:a_overwrite];
}

/*------------------------------------------------------------------------------------*/

@end
