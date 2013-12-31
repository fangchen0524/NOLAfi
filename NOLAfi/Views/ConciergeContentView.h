/*------------------------------------------------------------------------------------*/
//
//  ConciergeContentView.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 5/4/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "HomeContentView.h"
#import "ConciergeQuestionsTableView.h"

/*------------------------------------------------------------------------------------*/

@interface ConciergeContentView : HomeContentView

/*------------------------------------------------------------------------------------*/

@property (strong, nonatomic) IBOutlet UIView * infoView;
@property (strong, nonatomic) IBOutlet UIButton * infoButton;
@property (strong, nonatomic) IBOutlet UILabel * infoLabel;
@property (strong, nonatomic) IBOutlet UIImageView * infoArrowImage;
@property (strong, nonatomic) IBOutlet ConciergeQuestionsTableView * questionsTableView;

/*------------------------------------------------------------------------------------*/

- (IBAction)nextQuestionButtonAction:(id)sender;
- (IBAction)prevQuestionButtonAction:(id)sender;
- (IBAction)doneQuestionButtonAction:(id)sender;

/*------------------------------------------------------------------------------------*/

@end
