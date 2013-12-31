/*------------------------------------------------------------------------------------*/
//
//  NSString+MD5.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "NSString+MD5.h"

/*------------------------------------------------------------------------------------*/

@implementation NSString (MD5)

/*------------------------------------------------------------------------------------*/

+ (NSString*)md5EncodedString:(NSString*)a_string
{
    const char *cStr = [a_string UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

/*------------------------------------------------------------------------------------*/

- (NSString*)md5EncodedString
{
	return [NSString md5EncodedString:self];
}

/*------------------------------------------------------------------------------------*/

@end
