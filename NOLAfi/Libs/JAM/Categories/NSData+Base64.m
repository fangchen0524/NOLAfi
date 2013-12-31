/*------------------------------------------------------------------------------------*/
//
//  NSData+Base64.m
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//
/*------------------------------------------------------------------------------------*/

#import "NSData+Base64.h"

/*------------------------------------------------------------------------------------*/

@implementation NSData (Base64)

/*------------------------------------------------------------------------------------*/

+ (NSString*)base64EncodedString:(NSData*)a_data
{
    const uint8_t* input = (const uint8_t*)[a_data bytes];
    NSInteger length = [a_data length];

    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;

    NSInteger i;
    for (i=0; i < length; i += 3) 
    {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) 
        {
            value <<= 8;
            
            if (j < length) 
            {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }

    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

/*------------------------------------------------------------------------------------*/

- (NSString*)base64EncodedString
{
    return [NSData base64EncodedString:self];
}

/*------------------------------------------------------------------------------------*/

@end