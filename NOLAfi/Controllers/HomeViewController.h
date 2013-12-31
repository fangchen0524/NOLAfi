/*------------------------------------------------------------------------------------*/
//
//  HomeViewController.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 12/14/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMViewController.h"
#import "HomeContentView.h"
#import "EventsContentView.h"
#import "PlacesContentView.h"
#import "ConciergeContentView.h"
#import "TicketsContentView.h"

/*------------------------------------------------------------------------------------*/

@interface HomeViewController : JAMViewController

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UIView * contentView;

// *** NOTE ***
// If we set these to strong, the content views will stay around, but, this might cause
// too much memory use.
// *** NOTE ***
@property (nonatomic, weak, readonly) EventsContentView * eventsContentView;
@property (nonatomic, weak, readonly) PlacesContentView * placesContentView;
@property (nonatomic, weak, readonly) ConciergeContentView * conciergeContentView;
@property (nonatomic, weak, readonly) TicketsContentView * ticketsContentView;

/*------------------------------------------------------------------------------------*/

- (HomeContentView*)getCurrentContentView;

/*------------------------------------------------------------------------------------*/

@end
