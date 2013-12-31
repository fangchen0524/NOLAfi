/*------------------------------------------------------------------------------------*/
//
//  JAMViewController.m
//
//  Created by Jonathan Morin
//  Copyright (c) 2011,2012,2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "JAMViewController.h"
#import "UIView+Custom.h"

/*------------------------------------------------------------------------------------*/
// Implementation
/*------------------------------------------------------------------------------------*/

@implementation JAMViewController

/*------------------------------------------------------------------------------------*/
// Synthesize
/*------------------------------------------------------------------------------------*/

@synthesize currTextField = _currTextField;
@synthesize orderedTextFields = _orderedTextFields;

@synthesize adjustViewInitialFrame = _adjustViewInitialFrame;
@synthesize keyboardShowing = _keyboardShowing;
@synthesize kbDoneButton = _kbDoneButton;
@synthesize kbNextButton = _kbNextButton;
@synthesize kbPreviousButton = _kbPreviousButton;

/*------------------------------------------------------------------------------------*/

- (id)init
{
	self = [super init];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	// Do nothing
}

/*------------------------------------------------------------------------------------*/
// Delegate/Class Overrides
/*------------------------------------------------------------------------------------*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add keyboard observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*------------------------------------------------------------------------------------*/
// Custom
/*------------------------------------------------------------------------------------*/

- (UIViewController*)findNavParentForViewController:(UIViewController*)a_controller
{
    UIViewController * parentController = nil;
    for (UIViewController * controller in a_controller.navigationController.viewControllers)
    {
        if (controller == a_controller)
        {
            break;
        }
        
        parentController = controller;
    }
    
    return parentController;
}

/*------------------------------------------------------------------------------------*/
// Setup
/*------------------------------------------------------------------------------------*/

- (void)setupTextField:(UITextField*)a_textField useBorder:(BOOL)a_useBorder useDone:(BOOL)a_useDone usePrevNext:(BOOL)a_usePrevNext
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::setupTextField <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    if (!a_useBorder)
    {
        a_textField.borderStyle = UITextBorderStyleNone;
    }

	if (!a_useDone && !a_usePrevNext)
	{
		return;
	}
    
    // Create toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar sizeToFit];

    // Prev and next buttons
    if (a_usePrevNext)
    {
        // Previous button
        _kbPreviousButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(textFieldPrevious)];
        // Next Button
        _kbNextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(textFieldNext)];
    }
    
    // Done Button and Flex button
    _kbDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone)];
    UIBarButtonItem * flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Create button array
    NSArray * itemsArray = nil;
    if (a_usePrevNext)
    {
		if (a_useDone)
		{
			itemsArray = [NSArray arrayWithObjects:_kbPreviousButton, _kbNextButton, flexButton, _kbDoneButton, nil];
		}
		else
		{
			itemsArray = [NSArray arrayWithObjects:_kbPreviousButton, _kbNextButton, nil];
		}
    }
    else if (a_useDone)
    {
        itemsArray = [NSArray arrayWithObjects:flexButton, _kbDoneButton, nil];
    }
    
    // Add button array to toolbar
    [toolbar setItems:itemsArray];
    
    // Add toolbar to textfield
    [a_textField setInputAccessoryView:toolbar];
}

/*------------------------------------------------------------------------------------*/
// Keyboard Notifications
/*------------------------------------------------------------------------------------*/

- (void)keyboardWillShowNotification:(NSNotification*)a_notification
{   
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::keyboardWillShowNotification <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    _keyboardShowing = YES;
}

/*------------------------------------------------------------------------------------*/

- (void)keyboardWillHideNotification:(NSNotification*)a_notification
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::keyboardWillHideNotification <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    self.currTextField = nil;
    
    _keyboardShowing = NO;
}

/*------------------------------------------------------------------------------------*/

- (void)adjustViewAnimated:(UIView*)a_view offset:(CGFloat)a_offset animated:(BOOL)a_animated reset:(BOOL)a_reset
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::adjustViewAnimated <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    UIView * view = a_view;
    if (!view)
    {
        view = self.view;
    }
    
    if (CGRectIsEmpty(self.adjustViewInitialFrame))
    {
        _adjustViewInitialFrame = view.frame;
    }
    
    if ((a_offset != 0.0) ||
        (a_reset))
    {
        CGRect frame = self.view.frame;
        
        if (a_reset)
        {
            frame = self.adjustViewInitialFrame;
            a_offset = 0.0;
            
            [self doResignFirstResponder:self.currTextField];
        }
        else 
        {
            if (![view isKindOfClass:[UIScrollView class]])
            {
                frame.origin.y = (_adjustViewInitialFrame.origin.y + a_offset);
            }
        }
        
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:(a_animated ? kDefaultAnimationDuration : 0)
								  delay:0.0 
								options:UIViewAnimationOptionCurveEaseInOut
							 animations:^{
								 if ([view isKindOfClass:[UIScrollView class]])
								 {
									 UIScrollView * scrollView = (UIScrollView*)view;
									 scrollView.contentOffset = CGPointMake(0, a_offset);
								 }
								 else
								 {
									 view.frame = frame;
								 }
							 }
							 completion:^(BOOL finished){
								 [self performSelector:@selector(adjustViewAnimationCompletionSelector)];
							 }         
			 ];
		});
    }
}

/*------------------------------------------------------------------------------------*/

- (void)adjustViewAnimationCompletionSelector
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::adjustViewAnimationCompletionSelector <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
}

/*------------------------------------------------------------------------------------*/

- (void)doResignFirstResponder:(id)a_object
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::doResignFirstResponder <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    if (([a_object respondsToSelector:@selector(resignFirstResponder)]) &&
        ([a_object isFirstResponder]))
    {
        [a_object resignFirstResponder];
    }
}

/*------------------------------------------------------------------------------------*/

- (void)textFieldDone
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::textFieldDone <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    [self doResignFirstResponder:self.currTextField];
}

/*------------------------------------------------------------------------------------*/

- (void)textFieldPrevious
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::textFieldPrevious <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
}

/*------------------------------------------------------------------------------------*/

- (void)textFieldNext
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::textFieldNext <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
}

/*------------------------------------------------------------------------------------*/
// TextField
/*------------------------------------------------------------------------------------*/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::textFieldDidBeginEditing <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    self.currTextField = textField;
	
	[self.currTextField becomeFirstResponder];
}

/*------------------------------------------------------------------------------------*/
 
- (void)textFieldDidEndEditing:(UITextField *)textField
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::textFieldDidEndEditing <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
}

/*------------------------------------------------------------------------------------*/

- (IBAction)textFieldDidEnd:(id)a_sender
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::textFieldDidEnd <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
    [self doResignFirstResponder:a_sender];
}

/*------------------------------------------------------------------------------------*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
#if DEBUG_JAMVIEWCONTROLLER
    debug NSLog(@">> JAMViewController::textFieldShouldEndEditing <<");
#endif // #if DEBUG_JAMVIEWCONTROLLER
    
	[self doResignFirstResponder:self.currTextField];
    
	return YES;
}

/*------------------------------------------------------------------------------------*/

@end
