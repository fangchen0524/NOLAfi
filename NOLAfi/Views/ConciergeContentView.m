/*------------------------------------------------------------------------------------*/
//
//  ConciergeContentView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 5/4/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "ConciergeContentView.h"
#import "JAMWebView.h"

/*------------------------------------------------------------------------------------*/

@interface ConciergeContentView() <UIGestureRecognizerDelegate>
{
	IBOutlet UIView * _askAmyView;
	IBOutlet UITextView * _welcomeTextView;
	IBOutlet UIButton * _drawerButton;
	IBOutlet UIView * _filterView;
	IBOutlet UIButton * _filterButton;
	IBOutlet UILabel * _questionLabel;
	IBOutlet UIButton * _nextQuestionButton;
	IBOutlet UIButton * _prevQuestionButton;
	
	BOOL _filterOverlayAnimating;
	BOOL _done;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation ConciergeContentView

/*------------------------------------------------------------------------------------*/

- (void)dealloc
{
	// Remove observers
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kConciergeNextNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	// Call super
	[super awakeFromNib];

	_welcomeTextView.text = @"Welcome to NOLAfi,\n\nWe know how great travel advice can make the difference between a fun trip and an extraordinary experience. NOLAfi will give you the info, sounds and views of New Orleans 365 days a year. Enjoy!";
	
	// Add observers
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conciergeNextNotification:) name:kConciergeNextNotification object:nil];
	
	// Add action to button
	[_drawerButton addTarget:self action:@selector(showHideDrawer:) forControlEvents:UIControlEventTouchDown];

	// Setup concierge table view
	self.questionsTableView.questionLabel = _questionLabel;
	self.questionsTableView.questionCountLabel = _infoLabel;
	_prevQuestionButton.hidden = YES;
	_nextQuestionButton.hidden = NO;
	
	// Add swipe gesture recognizers
	UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
	recognizer.delegate = self;
	recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self addGestureRecognizer:recognizer];
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)];
	recognizer.delegate = self;
	recognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self addGestureRecognizer:recognizer];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)showHideDrawer:(id)sender
{
	// Post drawer notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kHomeShowHideDrawerNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)nextQuestionButtonAction:(id)sender
{
	_nextQuestionButton.hidden = YES;
	if ([self.questionsTableView nextQuestion])
	{
		_nextQuestionButton.hidden = NO;
	}
	_prevQuestionButton.hidden = NO;
}

/*------------------------------------------------------------------------------------*/

- (IBAction)prevQuestionButtonAction:(id)sender
{
	_prevQuestionButton.hidden = YES;
	if ([self.questionsTableView prevQuestion])
	{
		_prevQuestionButton.hidden = NO;
	}
	_nextQuestionButton.hidden = NO;
}

/*------------------------------------------------------------------------------------*/

- (IBAction)doneQuestionButtonAction:(id)sender
{
	
}

/*------------------------------------------------------------------------------------*/

- (IBAction)filterButtonAction:(id)sender
{
	if (_filterOverlayAnimating)
	{
		return;
	}
	
	_filterButton.selected = !_filterButton.selected;
	
	if (_filterButton.selected)
	{
		CGRect frame = _filterView.frame;
		frame.origin.y = -frame.size.height;
		_filterView.frame = frame;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:kDefaultAnimationDuration
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^{
								 CGRect frame = _filterView.frame;
								 frame.origin.y = 45;
								 _filterView.frame = frame;
								 _filterView.hidden = NO;
								 _filterOverlayAnimating = YES;
							 }
							 completion:^(BOOL finished){
								 _filterOverlayAnimating = NO;
							 }
			 ];
		});
	}
	else
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:kDefaultAnimationDuration
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseOut
							 animations:^{
								 CGRect frame = _filterView.frame;
								 frame.origin.y -= frame.size.height;
								 _filterView.frame = frame;
								 _filterOverlayAnimating = YES;
							 }
							 completion:^(BOOL finished){
								 _filterView.hidden = YES;
								 _filterOverlayAnimating = NO;
							 }
			 ];
		});
	}
}

/*------------------------------------------------------------------------------------*/

- (IBAction)letsGetStartedButtionAction:(id)sender
{
	[self.questionsTableView nextQuestion];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:kDefaultAnimationDuration
						 animations:^{
							 _askAmyView.alpha = 0.0;
							 _filterView.hidden = NO;
							 _filterView.alpha = 1.0;
							 _infoView.hidden = NO;
							 _infoArrowImage.hidden = NO;
						 }
						 completion:^(BOOL finished){
							 _askAmyView.hidden = YES;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Gesture Methods
/*------------------------------------------------------------------------------------*/

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer*)a_recognizer
{
	[self nextQuestionButtonAction:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer*)a_recognizer
{
	[self prevQuestionButtonAction:nil];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Notification Methods
/*------------------------------------------------------------------------------------*/

- (void)conciergeNextNotification:(NSNotification*)a_notification
{
	[self nextQuestionButtonAction:nil];
}

/*------------------------------------------------------------------------------------*/

@end
