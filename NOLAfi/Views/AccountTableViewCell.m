/*------------------------------------------------------------------------------------*/
//
//  AccountTableViewCell.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/16/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "AccountTableViewCell.h"

/*------------------------------------------------------------------------------------*/

@interface AccountTableViewCell()
{
	IBOutlet UIButton * _settingsButton;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation AccountTableViewCell

/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	// Add observers
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookPictureNotification:) name:kFacebookPictureNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[_settingsButton addTarget:self action:@selector(settingsButtonAction:) forControlEvents:UIControlEventTouchDown];
	
	self.accountImageView.layer.cornerRadius = 4;
	self.accountImageView.layer.masksToBounds = YES;

	self.facebookImageView.layer.cornerRadius = 2;
	self.facebookImageView.layer.masksToBounds = YES;
}

/*------------------------------------------------------------------------------------*/

- (void)dealloc
{
	// Remove observers
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kFacebookPictureNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)facebookPictureNotification:(NSNotification*)a_notification
{
	if (a_notification.userInfo)
	{
		self.accountImageView.image = [a_notification.userInfo objectForKey:@"image"];
		
		NSDictionary * facebookDict = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookUserDataKey];
		self.accountNameLabel.text = [NSString stringWithFormat:@"%@ %@",
									  [facebookDict objectForKey:@"first_name"],
									  [facebookDict objectForKey:@"last_name"]];
		
		self.facebookImageView.hidden = NO;
	}
}

/*------------------------------------------------------------------------------------*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*------------------------------------------------------------------------------------*/

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSEnumerator * reverseE = [self.subviews reverseObjectEnumerator];
    UIView * iSubView = nil;
    while ((iSubView = [reverseE nextObject]))
	{
        UIView * viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if (viewWasHit)
		{
            return viewWasHit;
        }
    }
	
    return [super hitTest:point withEvent:event];
}

/*------------------------------------------------------------------------------------*/

- (IBAction)settingsButtonAction:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kAccountButtonNotification object:self userInfo:nil];
}

/*------------------------------------------------------------------------------------*/

@end
