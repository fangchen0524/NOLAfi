/*-----------------------------------------------------------------------------------------*/
//
//  JAMAlert.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*-----------------------------------------------------------------------------------------*/

#import "JAMAlert.h"

/*-----------------------------------------------------------------------------------------*/
// AlertData Implmentation
/*-----------------------------------------------------------------------------------------*/

@implementation AlertData

/*-----------------------------------------------------------------------------------------*/

@synthesize delegate = _delegate;
@synthesize data = _data;

/*-----------------------------------------------------------------------------------------*/

- (void)dealloc
{
	self.delegate = nil;
}

/*-----------------------------------------------------------------------------------------*/

@end

/*-----------------------------------------------------------------------------------------*/
// JAMAlert Implementation
/*-----------------------------------------------------------------------------------------*/

@interface JAMAlert (Private)

- (void)alertCommon:(int)a_tag data:(NSDictionary*)a_data;
- (void)setAlertData:(NSDictionary*)a_data;

@end

/*-----------------------------------------------------------------------------------------*/

@implementation JAMAlert

/*------------------------------------------------------------------------------*/

+ (JAMAlert*)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
	
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
	
    return sharedInstance;
}

/*------------------------------------------------------------------------------*/

- (id)init
{
	self = [super init];
	
	if (self)
	{
		self.alertDataDict = [[NSMutableDictionary alloc] init];
	}
	
    return self;
}

/*-----------------------------------------------------------------------------------------*/

- (void)setAlertData:(NSDictionary*)a_data
{
	if (a_data)
	{
		NSNumber *tag = [a_data objectForKey:@"tag"];

		if (!tag)
		{
			debug NSLog(@"[WARNING] setAlertData: The data dictionary must contain a tag key/value pair!");
			return;
		}
		
		[self.alertDataDict setObject:a_data forKey:tag];
	}
}

/*-----------------------------------------------------------------------------------------*/

- (NSDictionary*)getAlertData:(int)a_tag
{
	return [self.alertDataDict objectForKey:[NSNumber numberWithInt:a_tag]];
}

/*-----------------------------------------------------------------------------------------*/

- (void)alertCommon:(int)a_tag
			   data:(NSDictionary*)a_data
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								 [NSNumber numberWithInt:a_tag], @"tag",
								 nil];
	if (a_data)
	{
		[dict addEntriesFromDictionary:a_data];
	}
	
	[[JAMAlert sharedInstance] setAlertData:dict];
}

/*-----------------------------------------------------------------------------------------*/

- (void)doYesNoAlert:(NSString*)a_title
			 message:(NSString*)a_message
				 tag:(int)a_tag
				data:(NSDictionary*)a_data
			delegate:(id)a_delegate
{
	[self alertCommon:a_tag data:a_data];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:a_title
													message:a_message
												   delegate:a_delegate 
										  cancelButtonTitle:@"NO" 
										  otherButtonTitles:@"YES",nil];
	[alert setTag:a_tag];
	[alert show];
}

/*-----------------------------------------------------------------------------------------*/

- (void)doOkAlert:(NSString*)a_title
		  message:(NSString*)a_message
			 data:(NSDictionary*)a_data
		 delegate:(id)a_delegate
{
	int tag = kAlertViewTagOk;
	NSNumber *tagObj = [a_data objectForKey:@"tag"];
	if (tagObj)
	{
		tag = [tagObj intValue];
	}
    
	[self alertCommon:tag data:a_data];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:a_title
													message:a_message
												   delegate:a_delegate 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert setTag:tag];
	[alert show];
}

/*-----------------------------------------------------------------------------------------*/

@end
