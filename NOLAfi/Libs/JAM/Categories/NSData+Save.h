/*------------------------------------------------------------------------------------*/
//
//  NSData+Save.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

/*------------------------------------------------------------------------------------*/

@interface NSData (Save)

/*------------------------------------------------------------------------------------*/

+ (UIImage*)saveAsImage:(NSData*)a_data fileName:(NSString*)a_fileName destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overwrite;

/*------------------------------------------------------------------------------------*/

- (UIImage*)saveAsImage:(NSString*)a_fileName destinationPath:(NSString*)a_destinationPath overWrite:(BOOL)a_overwrite;

/*------------------------------------------------------------------------------------*/

@end
