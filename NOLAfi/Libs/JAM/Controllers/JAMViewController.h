/*------------------------------------------------------------------------------------*/
//
//  JAMViewController.h
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#if DEBUG
#define DEBUG_JAMVIEWCONTROLLER    1
#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/
// Interface
/*------------------------------------------------------------------------------------*/

@interface JAMViewController : UIViewController <UITextFieldDelegate>

/*------------------------------------------------------------------------------------*/
// Properties
/*------------------------------------------------------------------------------------*/

@property (nonatomic, retain) UITextField * currTextField;
@property (nonatomic, retain) NSArray * orderedTextFields;

@property (nonatomic, assign, readonly) CGRect adjustViewInitialFrame;
@property (nonatomic, assign, readonly) CGFloat adjustOffset;
@property (nonatomic, assign, readonly) BOOL keyboardShowing;
@property (nonatomic, retain, readonly) UIBarButtonItem * kbDoneButton;
@property (nonatomic, retain, readonly) UIBarButtonItem * kbNextButton;
@property (nonatomic, retain, readonly) UIBarButtonItem * kbPreviousButton;

/*------------------------------------------------------------------------------------*/
// Instance Methods
/*------------------------------------------------------------------------------------*/

- (void)initCommon;

- (UIViewController*)findNavParentForViewController:(UIViewController*)a_controller;

- (void)setupTextField:(UITextField*)a_textField useBorder:(BOOL)a_useBorder useDone:(BOOL)a_useDone usePrevNext:(BOOL)a_usePrevNext;
- (void)keyboardWillShowNotification:(NSNotification*)a_notification;
- (void)keyboardWillHideNotification:(NSNotification*)a_notification;
- (void)adjustViewAnimated:(UIView*)a_view offset:(CGFloat)a_offset animated:(BOOL)a_animated reset:(BOOL)a_reset;
- (void)adjustViewAnimationCompletionSelector;
- (void)doResignFirstResponder:(id)a_object;
- (void)textFieldDone;
- (void)textFieldPrevious;
- (void)textFieldNext;

/*------------------------------------------------------------------------------------*/

@end
