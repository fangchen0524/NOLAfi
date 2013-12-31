/*------------------------------------------------------------------------------------*/
//
//  HomeViewController.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 12/14/12.
//  Copyright (c) 2012 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "HomeViewController.h"
#import "UIImageView+Mask.h"
#import "NSString+Convert.h"
#import "NSData+Save.h"
#import "HomeDrawerView.h"
#import "WebControllerHeaderView.h"
#import "JAMHitView.h"
#import "JAMWebViewController.h"
#import "JAMWebView.h"

#import "SearchViewController.h"
#import "TicketsViewController.h"
#import "AccountViewController.h"
#import "AboutViewController.h"

#if USE_PAYPAL
	#import "PayPalMobile.h"
	#import "PayPalPayment.h"
	#import "PayPalPaymentViewController.h"
#endif // #if USE_PAYPAL

#if DEBUG
	#import "TestWWOZVenuesViewController.h"
	#import "TestPlacesViewController.h"
	#import "TestWWOZEventsViewController.h"
	#import "TestProductsViewController.h"
	#import "TestArtistsViewController.h"
#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/
#pragma mark - Defines
#pragma mark -
/*------------------------------------------------------------------------------------*/

#define USE_SHADOWS	1

/*------------------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Types
/*------------------------------------------------------------------------------------*/

typedef enum
{
    kBounceNone,
    kBounceLeft,
    kBounceRight
} BounceDirection;

typedef enum
{
    kScrollNone,
    kScrollLeft,
    kScrollRight
} ScrollDirection;

typedef enum
{
    kScrollOriginNone,
    kScrollOriginLeft,
    kScrollOriginRight
} ScrollOriginSide;

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Interface
#pragma mark -
/*------------------------------------------------------------------------------------*/

@interface HomeViewController()
< UIScrollViewDelegate,
  UIGestureRecognizerDelegate
#if USE_PAYPAL
  , PayPalPaymentDelegate
#endif // #if USE_PAYPAL
>
{
	IBOutlet UIScrollView * _horizontalScrollView;
	IBOutlet HomeDrawerView * _homeDrawerView;
	
	CGPoint _lastVerticalScrollViewPoint;
	CGPoint _lastHorizontalScrollViewPoint;
	
	ScrollDirection _lastScrollDirection;
	ScrollOriginSide _lastScrollOriginSide;
	
	BOOL _wwozStreamState;
	BOOL _wwozDonateState;
	BOOL _slideAnimating;
	BOOL _stopScroll;
	
	UIView * _wwozDonateView;
}

- (IBAction)wwozButtonAction:(id)sender;
- (IBAction)searchButtonAction:(id)sender;

@end

/*------------------------------------------------------------------------------------*/
#pragma mark - Implementation
#pragma mark -
/*------------------------------------------------------------------------------------*/

@implementation HomeViewController

/*------------------------------------------------------------------------------------*/
#pragma mark - Override Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationController.navigationBarHidden = YES;
	self.navigationController.toolbarHidden = NO;

	// Add initial content view
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * contentView = [defaults objectForKey:kContentViewKey];
	if (isNSStringEmptyOrNil(contentView))
	{
		contentView = @"ConciergeContentView";
	}
	[self addContentView:contentView];
	
	// Setup scroll views
	_horizontalScrollView.contentSize = self.view.frame.size;
	_horizontalScrollView.contentOffset = CGPointMake(0, 0);
	
#if USE_SHADOWS
	self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.contentView.layer.shadowOffset = CGSizeMake(-4.0, 0.0);
	self.contentView.layer.shadowOpacity = 0.75;
#endif // #if USE_SHADOWS

	// Start WWOZ stream
	_wwozStreamState = YES;
	[self updateWWOZAudioStream];
	
	// Add tap gesture recognizer to navigation toolbar
	UITapGestureRecognizer * recognizer = nil;
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToolbarTap:)];
	recognizer.numberOfTouchesRequired = 1;
	recognizer.delegate = self;
	[self.navigationController.toolbar addGestureRecognizer:recognizer];
	
    // Register view hit tests
    if ([self.view isKindOfClass:[JAMHitView class]])
    {
        JAMHitView * hitView = (JAMHitView*)self.view;
        [hitView registerHitTest:@"scrollViewHitTest:point:"];
        [hitView setRegisteredHitDelegate:self];
    }

	// Hide things on initial load
	self.view.alpha = 0.0;
	self.contentView.alpha = 0.0;
	self.navigationController.toolbar.alpha = 0.0;
}

/*------------------------------------------------------------------------------------*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.navigationController.navigationBarHidden = YES;
	self.navigationController.toolbarHidden = NO;

//	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	// Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsButtonNotification:) name:kEventsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placesButtonNotification:) name:kPlacesButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conciergeButtonNotification:) name:kConciergeButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aboutButtonNotification:) name:kAboutButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ticketsButtonNotification:) name:kTicketsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHideButtonNotification:) name:kHomeShowHideDrawerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountButtonNotification:) name:kAccountButtonNotification object:nil];
#if DEBUG
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testRequestProductsFinishedNotification:) name:kRequestProductsFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testWWOZVenuesButtonNotification:) name:kTestWWOZVenuesButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testWWOZEventsButtonNotification:) name:kTestWWOZEventsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNOLAPlacesButtonNotification:) name:kTestNOLAPlacesButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testSaveOrderButtonNotification:) name:kTestOrderSaveButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testProductsButtonNotification:) name:kTestProductsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testArtistsButtonNotification:) name:kTestArtistsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testPayPalButtonNotification:) name:kTestPayPalButtonNotification object:nil];
#endif // #if DEBUG

	// Prepare PayPal
#if USE_PAYPAL
#if DEBUG
	NSString * payPalEnvironment = PayPalEnvironmentSandbox;
#else
	NSString * payPalEnvironment = PayPalEnvironmentProduction;
#endif
	[PayPalPaymentViewController setEnvironment:payPalEnvironment];
	[PayPalPaymentViewController prepareForPaymentUsingClientId:kPayPalClientID];
#endif // USE_PAYPAL
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// Force user to login
	if (![[AppDelegate sharedDelegate] loggedIn])
	{
		AccountViewController * controller = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
		controller.newLogin = YES;
		[self presentViewController:controller animated:YES completion:nil];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	// Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kEventsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPlacesButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kConciergeButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAboutButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTicketsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHomeShowHideDrawerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountButtonNotification object:nil];
#if DEBUG
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestProductsFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTestWWOZVenuesButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTestWWOZEventsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTestNOLAPlacesButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTestOrderSaveButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTestProductsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTestArtistsButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTestPayPalButtonNotification object:nil];
#endif // #if DEBUG
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Gesture Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)handleToolbarTap:(UITapGestureRecognizer*)a_recognizer
{
	CGRect frame = self.navigationController.toolbar.frame;
	CGPoint point = [a_recognizer locationInView:self.navigationController.toolbar];
	if (CGRectContainsPoint(CGRectMake(0, 0, 60, 50), point))
	{
		[self wwozRadioButtonAction:nil];
	}
	else if (CGRectContainsPoint(CGRectMake((frame.size.width - 140), 0, 140, 50), point))
	{
		[self wwozDonateButtonAction:nil];
	}
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Notification Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)eventsButtonNotification:(NSNotification*)a_notification
{
	if (![[self getCurrentContentView] isKindOfClass:[EventsContentView class]])
	{
		[self addContentView:@"EventsContentView"];
	}
	
	[self doSlideLeftAnimation];
}

/*------------------------------------------------------------------------------------*/

- (void)placesButtonNotification:(NSNotification*)a_notification
{
	if (![[self getCurrentContentView] isKindOfClass:[PlacesContentView class]])
	{
		[self addContentView:@"PlacesContentView"];
	}
	
	[self doSlideLeftAnimation];
}

/*------------------------------------------------------------------------------------*/

- (void)conciergeButtonNotification:(NSNotification*)a_notification
{
	if (![[self getCurrentContentView] isKindOfClass:[ConciergeContentView class]])
	{
		[self addContentView:@"ConciergeContentView"];
	}
	
	[self doSlideLeftAnimation];
}

/*------------------------------------------------------------------------------------*/

- (void)aboutButtonNotification:(NSNotification*)a_notification
{
	AboutViewController * controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	[self presentViewController:controller animated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)ticketsButtonNotification:(NSNotification*)a_notification
{
	if (![[self getCurrentContentView] isKindOfClass:[TicketsContentView class]])
	{
		[self addContentView:@"TicketsContentView"];
	}
	
	[self doSlideLeftAnimation];
}

/*------------------------------------------------------------------------------------*/

#if DEBUG

- (void)testWWOZVenuesButtonNotification:(NSNotification*)a_notification
{
	TestWWOZVenuesViewController * controller = [[TestWWOZVenuesViewController alloc] initWithNibName:@"TestWWOZVenuesViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#if DEBUG

- (void)testWWOZEventsButtonNotification:(NSNotification*)a_notification
{
	TestWWOZEventsViewController * controller = [[TestWWOZEventsViewController alloc] initWithNibName:@"TestWWOZEventsViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#if DEBUG

- (void)testNOLAPlacesButtonNotification:(NSNotification*)a_notification
{
	TestPlacesViewController * controller = [[TestPlacesViewController alloc] initWithNibName:@"TestPlacesViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#if DEBUG

- (void)testSaveOrderButtonNotification:(NSNotification*)a_notification
{
	NSDictionary * fieldDict = [NSDictionary dictionaryWithObjectsAndKeys:
								@"123.45", @"amount",						// total amount of transaction as floating number, ex. 99.09
								@"Test Order", @"description",				// brief description of order, like 'Bus Ticket Order'
								@"Jonathan", @"first_name",					// billing first name
								@"Morin", @"last_name",						// billing last name
								@"216 Vista Rom Way", @"address",			// billing address
								@"San Jose", @"city",						// billing city
								@"CA", @"state",							// billing state
								@"95136", @"zip",							// billing zip code
								@"4085070143", @"phone",					// billing phone
								@"Jonathan", @"ship_to_first_name",			// shipping first name
								@"Morin", @"ship_to_last_name",				// shipping last name
								@"216 Vista Roma Way", @"ship_to_address",	// shipping address
								@"San Jose", @"ship_to_city",				// shipping city
								@"CA", @"ship_to_state",					// shipping state
								@"95136", @"ship_to_zip",					// shipping zip code
								@"jmorin927@me.com", @"email",				// email address
								@"5424000000000015", @"card_num",			// credit card number // use 5424000000000015 for testing
								@"1234", @"card_code",						// credit card security code
								@"01", @"exp_month",						// credit card expiration month (MM)
								@"2013", @"exp_year",						// credit card expiration year (YYYY)
								@"No Items", @"order_details",				// JSON array of order items, anything can be specified here, we are saving as a string for now
								nil];
	[[AppDelegate sharedDelegate] requestOrderSave:fieldDict];
}

#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#if DEBUG

- (void)testProductsButtonNotification:(NSNotification*)a_notification
{
	[[AppDelegate sharedDelegate] requestProducts];
}

#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#if DEBUG

- (void)testRequestProductsFinishedNotification:(NSNotification*)a_notification
{
	TestProductsViewController * controller = [[TestProductsViewController alloc] initWithNibName:@"TestPlacesViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#if DEBUG

- (void)testArtistsButtonNotification:(NSNotification*)a_notification
{
	TestArtistsViewController * controller = [[TestArtistsViewController alloc] initWithNibName:@"TestArtistsViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

#endif // #if DEBUG

/*------------------------------------------------------------------------------------*/

#if DEBUG && USE_PAYPAL

- (void)testPayPalButtonNotification:(NSNotification*)a_notification
{
	// Create a PayPalPayment
	PayPalPayment * payment = [[PayPalPayment alloc] init];
	payment.amount = [[NSDecimalNumber alloc] initWithString:@"29.95"];
	payment.currencyCode = @"USD";
	payment.shortDescription = @"Hop-On Hop-Off Bus Ride";
	
	// Check whether payment is processable.
	if (payment.processable)
	{
		// Start out working with the test environment! When you are ready, remove this line to switch to live.
		[PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
		
		// Provide a payerId that uniquely identifies a user within the scope of your system,
		// such as an email address or user ID.
		NSString * aPayerId = @"jmorin927@gmail.com";
		
		// Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
		// from the previous step, and a PayPalPaymentDelegate to handle the results.
		PayPalPaymentViewController * paymentViewController;
		paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:kPayPalClientID
																		receiverEmail:kPayPalRecevierEmailAddress
																			  payerId:aPayerId
																			  payment:payment
																			 delegate:self];
		
		// Present the PayPalPaymentViewController.
		[self presentViewController:paymentViewController animated:YES completion:nil];
	}
}

#endif // #if DEBUG && USE_PAYPAL

/*------------------------------------------------------------------------------------*/

- (void)showHideButtonNotification:(NSNotification*)a_notification
{
	[self showHideDrawer:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)accountButtonNotification:(NSNotification*)a_notification
{
	AccountViewController * controller = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
	controller.displayInfo = YES;
	[self presentViewController:controller animated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Button Action Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (IBAction)wwozRadioButtonAction:(id)sender
{
	_wwozStreamState = !_wwozStreamState;

	[self updateWWOZAudioStream];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)wwozDonateButtonAction:(id)sender
{
	// Return if donation view is already up
	if (_wwozDonateState)
	{
		return;
	}

	// Instantiate wwoz donate view
	if (!_wwozDonateView)
	{
		// Instantiate header
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"WebControllerHeaderView" owner:self options:nil];
		WebControllerHeaderView * headerView = (WebControllerHeaderView*)[nib objectAtIndex:0];
		headerView.titleLabel.hidden = YES;
		headerView.titleImageView.hidden = NO;
		headerView.titleImageView.image = [UIImage imageNamed:@"wwoz-donate.png"];
		[headerView.backButton addTarget:self action:@selector(wwozDonateCloseButtonAction:) forControlEvents:UIControlEventTouchDown];

		// Instantiate donate view
		_wwozDonateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - ([UIApplication sharedApplication].statusBarFrame.size.height + kHomeScreenToolbarHeight)))];
		_wwozDonateView.backgroundColor = [UIColor whiteColor];
		[_wwozDonateView addSubview:headerView];
	
		// Instantiate web view
		CGRect frame = _wwozDonateView.frame;
		frame.origin.y = (headerView.frame.size.height - 2);
		frame.size.height = (_wwozDonateView.frame.size.height - frame.origin.y);
		JAMWebView * webView = [[JAMWebView alloc] initWithFrame:frame];
		webView.backgroundColor = [UIColor clearColor];
		webView.scalesPageToFit = YES;
		[webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 5.0;"];
		[webView loadRequestedUrlWithActivityIndicator:kWWOZDonateUrl];
		[_wwozDonateView addSubview:webView];
	}

	// Add parent view to home view
	[self.view addSubview:_wwozDonateView];
	
	// Animate in parent view
	dispatch_async(dispatch_get_main_queue(), ^{
		CGRect frame = _wwozDonateView.frame;
		frame.origin.y = SCREEN_HEIGHT;
		_wwozDonateView.frame = frame;
		_wwozDonateState = YES;
		[UIView animateWithDuration:0.33
						 animations:^{
							 CGRect frame = _wwozDonateView.frame;
							 frame.origin.y = 0;
							 _wwozDonateView.frame = frame;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/

- (IBAction)searchButtonAction:(id)sender
{
	SearchViewController * controller = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)showHideDrawer:(id)sender
{
    if (_slideAnimating)
    {
        return;
    }
	
    CGPoint contentOffset = _horizontalScrollView.contentOffset;
	
    if (contentOffset.x == -(_homeDrawerView.frame.size.width))
    {
        [self doSlideLeftAnimation];
    }
    else if (contentOffset.x == 0)
    {
        [self doSlideRightAnimation];
    }
}

/*------------------------------------------------------------------------------------*/

- (IBAction)webControllerHeaderBackButtonAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)wwozDonateCloseButtonAction:(id)sender
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.33
						 animations:^{
							 CGRect frame = _wwozDonateView.frame;
							 frame.origin.y = SCREEN_HEIGHT;
							 _wwozDonateView.frame = frame;
						 }
						 completion:^(BOOL finished){
							 [_wwozDonateView removeFromSuperview];
							 _wwozDonateState = NO;
						 }
		 ];
	});
}

/*------------------------------------------------------------------------------------*/
#pragma mark - JAMHitView Hit Tests
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (NSNumber*)scrollViewHitTest:(UIView*)a_hitView point:(NSValue*)a_valuePoint
{
    if ((a_hitView) &&
        (a_valuePoint) &&
        ([a_hitView isKindOfClass:[UIScrollView class]]))
    {
        CGPoint point = [a_valuePoint CGPointValue];
        UIScrollView * scrollView = (UIScrollView*)a_hitView;
        if ((point.x > (scrollView.contentOffset.x + scrollView.contentInset.left) &&
			 (point.x < scrollView.contentInset.left)))
        {
            return [NSNumber numberWithBool:YES];
        }
    }
    
    return [NSNumber numberWithBool:NO];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Custom Animations
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)doSlideLeftAnimation
{
    if (_slideAnimating)
    {
        return;
    }
	
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGPoint contentOffset = _horizontalScrollView.contentOffset;
                             contentOffset.x = 0;
                             [_horizontalScrollView setContentOffset:contentOffset animated:NO];
                             _slideAnimating = YES;
                         }
                         completion:^(BOOL finished) {
                             _slideAnimating = NO;
                         }
		 ];
    });
}

/*------------------------------------------------------------------------------------*/

- (void)doSlideRightAnimation
{
    if (_slideAnimating)
    {
        return;
    }
	
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGPoint contentOffset = _horizontalScrollView.contentOffset;
                             contentOffset.x = -_homeDrawerView.frame.size.width;
                             [_horizontalScrollView setContentOffset:contentOffset animated:NO];
                             _slideAnimating = YES;
                         }
                         completion:^(BOOL finished) {
                             _slideAnimating = NO;
                         }
		 ];
    });
}

/*------------------------------------------------------------------------------------*/
#pragma mark - UIScrollViewDelegate Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint contentOffset = scrollView.contentOffset;
	
	if (scrollView == _horizontalScrollView)
	{
		BOOL updateContentOffset = NO;
		if (contentOffset.y != _lastHorizontalScrollViewPoint.y)
		{
			contentOffset.y = _lastHorizontalScrollViewPoint.y;
			updateContentOffset = YES;
		}
		
		// Determine scroll direction
		if (contentOffset.x != _lastHorizontalScrollViewPoint.x)
		{
			ScrollDirection direction = kScrollLeft;
			if ((_lastHorizontalScrollViewPoint.x - contentOffset.x) > 0)
			{
				direction = kScrollRight;
			}
			_lastScrollDirection = direction;
			_lastHorizontalScrollViewPoint = contentOffset;
		}
		
		// Determine scroll origin side
		ScrollOriginSide side = kScrollOriginRight;
		if (contentOffset.x == 0)
		{
			side = kScrollOriginNone;
		}
		else if (contentOffset.x > 0)
		{
			side = kScrollOriginLeft;
		}
		_lastScrollOriginSide = side;

		if (updateContentOffset)
		{
			_horizontalScrollView.contentOffset = contentOffset;
		}
		
		// Determine content user interaction
		BOOL contentInteraction = YES;
		id content = [self getCurrentContentView];
		if ((content) &&
			(side != kScrollOriginNone))
		{
			contentInteraction = NO;
		}
		[content bringSubviewToFront:[content interactionOverlay]];
		[[content interactionOverlay] setHidden:contentInteraction];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self handleAutoSliding];
}

/*------------------------------------------------------------------------------------*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleAutoSliding];
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Handler Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)handleAutoSliding
{
    CGPoint contentOffset = _horizontalScrollView.contentOffset;
	
    if (_slideAnimating)
    {
        return;
    }
	
    if (_stopScroll)
    {
        if ((!_horizontalScrollView.decelerating) &&
            (!_horizontalScrollView.dragging))
        {
            _stopScroll = NO;
        }
        return;
    }
	
    if ((contentOffset.x >= 0) &&
        (_lastScrollOriginSide == kScrollOriginLeft))
    {
        return;
    }
	
    if (_lastScrollDirection == kScrollLeft)
    {
        if (abs(contentOffset.x) < abs(_homeDrawerView.frame.size.width * 0.9))
        {
            [self doSlideLeftAnimation];
        }
        else
        {
            [self doSlideRightAnimation];
        }
    }
    else if (_lastScrollDirection == kScrollRight)
    {
        if (abs(contentOffset.x) > abs(_homeDrawerView.frame.size.width * 0.1))
        {
            [self doSlideRightAnimation];
        }
        else
        {
            [self doSlideLeftAnimation];
        }
    }
}

/*------------------------------------------------------------------------------------*/
#pragma mark - PayPalPaymentDelegate Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

#if USE_PAYPAL

/*------------------------------------------------------------------------------------*/

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment
{
	// Payment was processed successfully; send to server for verification and fulfillment.
	[self verifyCompletedPayment:completedPayment];
	
	// Dismiss the PayPalPaymentViewController.
	[self dismissViewControllerAnimated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)payPalPaymentDidCancel
{
	// The payment was canceled; dismiss the PayPalPaymentViewController.
	[self dismissViewControllerAnimated:YES completion:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment
{
	// Send the entire confirmation dictionary
	NSData * confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
															options:0
															  error:nil];
	confirmation = confirmation;
	
	// Send confirmation to your server; your server should verify the proof of payment
	// and give the user their goods or services. If the server is not reachable, save
	// the confirmation and try again later.
}

/*------------------------------------------------------------------------------------*/

#endif // #if USE_PAYPAL

/*------------------------------------------------------------------------------------*/
#pragma mark - Private Methods
#pragma mark -
/*------------------------------------------------------------------------------------*/

- (void)updateWWOZAudioStream
{
	NSString * imageName = @"wwz-play.jpg";
	if (_wwozStreamState)
	{
		imageName = @"wwz-pause.jpg";
	}
	
	// Update toolbar background image
	[self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:imageName]
									   forToolbarPosition:UIToolbarPositionAny
											   barMetrics:UIBarMetricsDefault];
	
#if DEBUG
	// REMOVE-ME
//	self.navigationController.toolbar.alpha = 0.25;
	// REMOVE-ME
#endif // #if DEBUG
	
	// Update stream state
	if (_wwozStreamState)
	{
		if ([[AppDelegate sharedDelegate] avPlayer])
		{
			[[[AppDelegate sharedDelegate] avPlayer] play];
		}
		else
		{
			AVPlayer * player = [AVPlayer playerWithURL:[NSURL URLWithString:kWWOZStreamUrl]];
			if (player)
			{
				// Start streaming music
				[player setRate:1.0];
				[player play];
				
				// Save off player
				[[AppDelegate sharedDelegate] setAvPlayer:player];
			}
		}
	}
	else if ([[AppDelegate sharedDelegate] avPlayer])
	{
		[[[AppDelegate sharedDelegate] avPlayer] pause];
	}
}

/*------------------------------------------------------------------------------------*/

- (void)addContentView:(NSString*)a_className
{
	// Remove all sub views
	for (UIView * subView in [[self contentView] subviews])
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.5
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseOut
							 animations:^{
								 [subView setAlpha:0.0];
							 }
							 completion:^(BOOL finished){
								 [subView removeFromSuperview];
							 }
			 ];
		});
	}
	
	// Instantiate content view
	id contentView = [self instantiateContentView:a_className];
	
	// Add content to content view
	[[self contentView] addSubview:contentView];
	
	// Save off current content view
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:a_className forKey:kContentViewKey];
    [defaults synchronize];

	// Fade in once
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.5
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^{
								 self.view.alpha = 1.0;
								 self.contentView.alpha = 1.0;
								 self.navigationController.toolbar.alpha = 1.0;
							 }
							 completion:nil
			 ];
		});
	});
}

/*------------------------------------------------------------------------------------*/

- (id)instantiateContentView:(NSString*)a_className
{
	id contentView = nil;
	
	Class viewClass = NSClassFromString(a_className);
	
	if (viewClass == [EventsContentView class])
	{
		contentView = _eventsContentView;
		if (!contentView)
		{
			NSArray * nib = [[NSBundle mainBundle] loadNibNamed:a_className owner:nil options:nil];
			contentView = (HomeContentView*)[nib objectAtIndex:0];
			_eventsContentView = contentView;
		}
	}
	else if (viewClass == [PlacesContentView class])
	{
		contentView = _placesContentView;
		if (!contentView)
		{
			NSArray * nib = [[NSBundle mainBundle] loadNibNamed:a_className owner:nil options:nil];
			contentView = (HomeContentView*)[nib objectAtIndex:0];
			_placesContentView = contentView;
		}
	}
	else if (viewClass == [ConciergeContentView class])
	{
		contentView = _conciergeContentView;
		if (!contentView)
		{
			NSArray * nib = [[NSBundle mainBundle] loadNibNamed:a_className owner:nil options:nil];
			contentView = (HomeContentView*)[nib objectAtIndex:0];
			_conciergeContentView = contentView;
		}
	}
	else if (viewClass == [TicketsContentView class])
	{
		contentView = _ticketsContentView;
		if (!contentView)
		{
			NSArray * nib = [[NSBundle mainBundle] loadNibNamed:a_className owner:nil options:nil];
			contentView = (HomeContentView*)[nib objectAtIndex:0];
			_ticketsContentView = contentView;
		}
	}
	
	NSAssert([contentView isKindOfClass:viewClass], @">> HomeViewController::addContentView: 'contentView' is not of kind '%@'! <<", a_className);
	NSAssert([contentView respondsToSelector:@selector(homeViewController)], @">> HomeViewController::addContentView: 'contentView' does not respond to 'homeViewController'! <<");
	
	[contentView setAlpha:0.0];
	[contentView setHomeViewController:self];
	
	CGRect frame = [[self contentView] frame];
	[contentView setFrame:frame];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.5
							  delay:0.0
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^{
							 [contentView setAlpha:1.0];
                             
                             CGRect frame = [contentView frame];
                             NSLog(@"%.0f", frame.size.height);
						 }
						 completion:nil
		 ];
	});
	
	return contentView;
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Instance Methods
/*------------------------------------------------------------------------------------*/

- (HomeContentView*)getCurrentContentView
{
	for (HomeContentView * contentView in [[self contentView] subviews])
	{
		return contentView;
	}
	
	return nil;
}

/*------------------------------------------------------------------------------------*/

@end
