/*------------------------------------------------------------------------------------*/
//
//  NSString+Convert.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "NSString+Convert.h"

/*------------------------------------------------------------------------------------*/

@implementation NSString (Convert)

/*------------------------------------------------------------------------------------*/

static NSDictionary * htmlFilterDict;

/*
static char charFilterArray[] = {
	'\t',
	'\r',
	'\n'
};
static int charFilterArraySize = sizeof(charFilterArray);
*/ 

/*------------------------------------------------------------------------------------*/

+ (NSString*)flattenHTML:(NSString*)html
{
	if (!htmlFilterDict)
	{
		htmlFilterDict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"", @"&amp;",
						  @"'", @"&#039;",
						  @"'", @"&#39;",
						  @" ", @"%20",
						  @" ", @"&nbsp;",
						  @"\"", @"&quot;",
						  nil];
	}
	
	NSScanner * theScanner;
    NSString * text = nil;
    theScanner = [NSScanner scannerWithString:html];

	html = [html stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	html = [html stringByTrimmingCharactersInSet:[NSCharacterSet illegalCharacterSet]];
	
    while ([theScanner isAtEnd] == NO)
	{
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
	
//    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	NSArray * allKeys = [htmlFilterDict allKeys];
	for (NSString * key in allKeys)
	{
		html = [html stringByReplacingOccurrencesOfString:key withString:[htmlFilterDict objectForKey:key]];
	}
	
    return html;
}

/*------------------------------------------------------------------------------------*/

- (NSString*)flattenHTML
{
	return [NSString flattenHTML:self];
}

/*------------------------------------------------------------------------------------*/

@end
