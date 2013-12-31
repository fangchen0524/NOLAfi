/*------------------------------------------------------------------------------------*/
//
//  TestPlacesDetailsViewController.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 8/4/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "JAM.h"

/*------------------------------------------------------------------------------------*/

@interface TestPlacesDetailsViewController : UIViewController < UITableViewDelegate, UITableViewDataSource >

/*------------------------------------------------------------------------------------*/

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSDictionary * detailDict;

/*------------------------------------------------------------------------------------*/

@end
