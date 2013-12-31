/*------------------------------------------------------------------------------------*/
//
//  ConciergeQuestionsTableView.m
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/21/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import "ConciergeQuestionsTableView.h"
#import "ConciergeQuestionsTableViewCell.h"

/*------------------------------------------------------------------------------------*/

@interface ConciergeQuestionsTableView() <UITableViewDelegate, UITableViewDataSource>
{
	NSIndexPath	* _prevSelectedIndexPath;
	NSMutableArray * _selectedAnswersArray;
}
@end

/*------------------------------------------------------------------------------------*/

@implementation ConciergeQuestionsTableView

/*------------------------------------------------------------------------------------*/

static NSString * sQuestion[kNumQuestions] = {
	@"What is your 'Gender'?",											// kQuestionGender
	@"What is your 'Age'?",												// kQuestionAge
	@"Have you been to New Orleans?",									// kQuestionExperience
	@"When will you plan your trip to New Orleans?",					// kQuestionWhen
	@"What type of 'Activities' are you most interested in?",			// kQuestionActivities
	@"What type of 'Food' do you most lean toward?",					// kQuestionFood
	@"What type of 'Music' do you most wish to listen to and see?",		// kQuestionMusic
	@"What is your style of 'Hotel' or 'Place' to stay?",				// kQuestionAccommodations
};

static NSString * sQuestionKeyword[kNumQuestions] = {
	@"gender",															// kQuestionGender
	@"age",																// kQuestionAge
	@"experience",														// kQuestionExperience
	@"when",															// kQuestionWhen
	@"activities",														// kQuestionActivities
	@"food",															// kQuestionFood
	@"music",															// kQuestionMusic
	@"accomodations",													// kQuestionAccommodations
};

static BOOL sMultiSelectionQuestion[kNumQuestions] = {
	NO,																	// kQuestionGender
	NO,																	// kQuestionAge
	NO,																	// kQuestionExperience
	NO,																	// kQuestionWhen
	YES,																// kQuestionActivities
	YES,																// kQuestionFood
	YES,																// kQuestionMusic
	YES,																// kQuestionAccommodations
};

static NSString * sQuestionGender[] = {
	@"Male",
	@"Female",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionGender = (sizeof(sQuestionGender) / sizeof(NSString*));

static NSString * sQuestionAge[] = {
	@"18 and under",
	@"19 to 30",
	@"31 to 40",
	@"41 to 50",
	@"51 and over",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionAge = (sizeof(sQuestionAge) / sizeof(NSString*));

static NSString * sQuestionExperience[] = {
	@"Never been",
	@"Have been before",
	@"Visit once a year",
	@"Visit once a month",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionExperience = (sizeof(sQuestionExperience) / sizeof(NSString*));

static NSString * sQuestionWhen[] = {
	@"Less than a week in advance",
	@"1 month in advance",
	@"At least 3 months in advance",
	@"For next year",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionWhen = (sizeof(sQuestionWhen) / sizeof(NSString*));

static NSString * sQuestionActivities[] = {
	@"Love to Eat",
	@"Enjoy the Outdoors",
	@"Reading and Literature",
	@"Seeing Local Musicians",
	@"Learn the History",
	@"View the Arts & Stage",
	@"Family Outings",
	@"Late Night Wandering",
	@"Wine and Relax",
	@"Love to Shop Big Brands",
	@"Cocktails and Bars",
	@"Spa and Pampered",
	@"Love to Shop Local Brands",
	@"Hunting and Fishing",
	@"Corner Bar and Hidden Spots",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionActivities = (sizeof(sQuestionActivities) / sizeof(NSString*));

static NSString * sQuestionFood[] = {
	@"Southern Fried",
	@"Award Winning",
	@"Casual NOLA",
	@"Mom and Pop",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionFood = (sizeof(sQuestionFood) / sizeof(NSString*));

static NSString * sQuestionMusic[] = {
	@"Jazz",
	@"Gospel and Blues",
	@"Rock and Alternative",
	@"Cajun and Zydeco",
	@"Funk",
	@"Electronic",
	@"Classical and Opera",
	@"All Music",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionMusic = (sizeof(sQuestionMusic) / sizeof(NSString*));

static NSString * sQuestionAccommodations[] = {
	@"Class / Traditional",
	@"Boutique / Unique",
	@"Modern / Sleek",
	@"Historic",
	@"Bed and Breakfast",
	@"Group / Hostel",
	@"Camping / RV",
	@"Anything is fine",
	@"Prefer not to disclose",
};
static NSInteger sNumQuestionAccommodations = (sizeof(sQuestionAccommodations) / sizeof(NSString*));

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

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	
	if (self)
	{
		[self initCommon];
	}
	
	return self;
}

/*------------------------------------------------------------------------------------*/

- (void)initCommon
{
	self.delegate = self;
	self.dataSource = self;
}

/*------------------------------------------------------------------------------------*/

- (void)dealloc
{
	self.delegate = nil;
	self.dataSource = nil;
	
	// Remove observers
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kConciergeSelectedNotification object:nil];
}

/*------------------------------------------------------------------------------------*/

- (void)awakeFromNib
{
	[super awakeFromNib];

	// Add observers
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conciergeSelectedNotification:) name:kConciergeSelectedNotification object:nil];
	
	_currQuestion = -1;

	[self updateCurrQuestion];
}

/*------------------------------------------------------------------------------------*/

- (void)updateCurrQuestion
{
	NSString * label = @"Start";
	if (_currQuestion != -1)
	{
		_questionLabel.text = sQuestion[_currQuestion];
		[self loadCurrQuestionState];
		
		label = [NSString stringWithFormat:@"%i of %i", (self.currQuestion + 1), kNumQuestions];
		
		if (self.currQuestion == (kNumQuestions - 1))
		{
			BOOL selected = NO;
			for (NSInteger index = 0; index < _selectedAnswersArray.count; index++)
			{
				if ([[_selectedAnswersArray objectAtIndex:index] boolValue])
				{
					selected = YES;
					break;
				}
			}
			
			if (selected)
			{
				label = @"Done";
			}
		}
	}
	_questionCountLabel.text = label;
	
	_prevSelectedIndexPath = nil;

	[self reloadData];
}

/*------------------------------------------------------------------------------------*/

- (BOOL)nextQuestion
{
	[(ConciergeContentView*)[[((AppDelegate*)[AppDelegate sharedDelegate]) homeController] getCurrentContentView] nextQuestionButtonAction:nil];
	
	[self saveCurrQuestionState];
	
	BOOL rVal = YES;
	_currQuestion++;
	if (_currQuestion >= (kNumQuestions - 1))
	{
		_currQuestion = (kNumQuestions - 1);
		rVal = NO;;
	}
	
	[self updateCurrQuestion];
	
	return rVal;
}

/*------------------------------------------------------------------------------------*/

- (BOOL)prevQuestion
{
	[(ConciergeContentView*)[[((AppDelegate*)[AppDelegate sharedDelegate]) homeController] getCurrentContentView] prevQuestionButtonAction:nil];
	
	[self saveCurrQuestionState];
	
	BOOL rVal = YES;
	_currQuestion--;
	if (_currQuestion <= 0)
	{
		_currQuestion = 0;
		rVal = NO;;
	}
	
	[self updateCurrQuestion];
	
	return rVal;
}

/*------------------------------------------------------------------------------------*/

- (NSInteger)numberOfQuestionsForCurr
{
	return [ConciergeQuestionsTableView numberOfQuestionsForIndex:self.currQuestion];
}

/*------------------------------------------------------------------------------------*/

+ (NSInteger)numberOfQuestionsForIndex:(NSInteger)a_index
{
	if (a_index == kQuestionGender)
	{
		return sNumQuestionGender;
	}
	else if (a_index == kQuestionAge)
	{
		return sNumQuestionAge;
	}
	else if (a_index == kQuestionExperience)
	{
		return sNumQuestionExperience;
	}
	else if (a_index == kQuestionWhen)
	{
		return sNumQuestionWhen;
	}
	else if (a_index == kQuestionActivities)
	{
		return sNumQuestionActivities;
	}
	else if (a_index == kQuestionFood)
	{
		return sNumQuestionFood;
	}
	else if (a_index == kQuestionMusic)
	{
		return sNumQuestionMusic;
	}
	else if (a_index == kQuestionAccommodations)
	{
		return sNumQuestionAccommodations;
	}
	
	return 0;
}

/*------------------------------------------------------------------------------------*/

- (NSString*)questionsKeyForCurr
{
	return [ConciergeQuestionsTableView questionsKeyForIndex:self.currQuestion];
}

/*------------------------------------------------------------------------------------*/

+ (NSString*)questionsKeyForIndex:(NSInteger)a_index
{
	NSString * key = nil;
	
	if (a_index == kQuestionGender)
	{
		key = kQuestionGenderKey;
	}
	else if (a_index == kQuestionAge)
	{
		key = kQuestionAgeKey;
	}
	else if (a_index == kQuestionExperience)
	{
		key = kQuestionExperienceKey;
	}
	else if (a_index == kQuestionWhen)
	{
		key = kQuestionWhenKey;
	}
	else if (a_index == kQuestionActivities)
	{
		key = kQuestionActivitiesKey;
	}
	else if (a_index == kQuestionFood)
	{
		key = kQuestionFoodKey;
	}
	else if (a_index == kQuestionMusic)
	{
		key = kQuestionMusicKey;
	}
	else if (a_index == kQuestionAccommodations)
	{
		key = kQuestionAccommodationsKey;
	}
	
	return key;
}

/*------------------------------------------------------------------------------------*/

+ (NSString*)questionForIndex:(NSInteger)a_index
{
	debug NSAssert((a_index >= 0 && a_index < kNumQuestions), @">> ConciergeQuestionsTableView::questionForIndex: a_index '%i' out of range! <<", a_index);
	
	return sQuestion[a_index];
}

/*------------------------------------------------------------------------------------*/

+ (NSString*)questionKeywordForIndex:(NSInteger)a_index
{
	debug NSAssert((a_index >= 0 && a_index < kNumQuestions), @">> ConciergeQuestionsTableView::questionKeywordForIndex: a_index '%i' out of range! <<", a_index);
	
	return sQuestionKeyword[a_index];
}

/*------------------------------------------------------------------------------------*/

+ (NSString*)answerForQuestion:(NSInteger)a_questionIndex subIndex:(NSInteger)a_answerIndex
{
	if (a_questionIndex == kQuestionGender)
	{
		return sQuestionGender[a_answerIndex];
	}
	else if (a_questionIndex == kQuestionAge)
	{
		return sQuestionAge[a_answerIndex];
	}
	else if (a_questionIndex == kQuestionExperience)
	{
		return sQuestionExperience[a_answerIndex];
	}
	else if (a_questionIndex == kQuestionWhen)
	{
		return sQuestionWhen[a_answerIndex];
	}
	else if (a_questionIndex == kQuestionActivities)
	{
		return sQuestionActivities[a_answerIndex];
	}
	else if (a_questionIndex == kQuestionFood)
	{
		return sQuestionFood[a_answerIndex];
	}
	else if (a_questionIndex == kQuestionMusic)
	{
		return sQuestionMusic[a_answerIndex];
	}
	else if (a_questionIndex == kQuestionAccommodations)
	{
		return sQuestionAccommodations[a_answerIndex];
	}
	
	return nil;
}

/*------------------------------------------------------------------------------------*/

- (void)loadCurrQuestionState
{
	_selectedAnswersArray = [[[NSUserDefaults standardUserDefaults] objectForKey:[self questionsKeyForCurr]] mutableCopy];
	if (!_selectedAnswersArray)
	{
		_selectedAnswersArray = [NSMutableArray array];
		for (NSInteger index = 0; index < [self numberOfQuestionsForCurr]; index++)
		{
			[_selectedAnswersArray addObject:[NSNumber numberWithBool:NO]];
		}
	}
}

/*------------------------------------------------------------------------------------*/

- (void)saveCurrQuestionState
{
	NSString * key = [self questionsKeyForCurr];
	if (key)
	{
		[[NSUserDefaults standardUserDefaults] setObject:_selectedAnswersArray forKey:key];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

/*------------------------------------------------------------------------------------*/
// UITableViewDelegate / UITableViewDataSource
/*------------------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self numberOfQuestionsForCurr];
}

/*------------------------------------------------------------------------------------*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 64;
}

/*------------------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * sCellIdentifier = @"ConciergeQuestionsTableViewCellIdentifier";
	
	ConciergeQuestionsTableViewCell * cell = [self dequeueReusableCellWithIdentifier:sCellIdentifier];
	if (!cell)
	{
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ConciergeQuestionsTableViewCell" owner:nil options:nil];
		cell = (ConciergeQuestionsTableViewCell*)[nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		CGRect buttonFrame = cell.button.frame;
		CGRect titleFrame = CGRectMake((buttonFrame.origin.x + 5),
									   (buttonFrame.origin.y + 5),
									   (buttonFrame.size.width - 10),
									   (buttonFrame.size.height - 10));
		cell.button.titleLabel.frame = titleFrame;
		cell.button.titleLabel.numberOfLines = 1;
		cell.button.titleLabel.minimumScaleFactor = 0.5;
	}
	
	cell.button.titleLabel.text = nil;
	cell.button.selected = NO;
	cell.selected = NO;
	cell.tag = indexPath.row;

	cell.button.titleLabel.text = [ConciergeQuestionsTableView answerForQuestion:self.currQuestion subIndex:indexPath.row];
	
	[cell.button setTitle:[cell.button.titleLabel.text uppercaseString] forState:UIControlStateNormal];
	[cell.button setTitle:[cell.button.titleLabel.text uppercaseString] forState:UIControlStateSelected];
	[cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

	// Determine cell button selected state
	NSString * key = [self questionsKeyForCurr];
	NSArray * values = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (values.count)
	{
		debug NSAssert((values.count == [self numberOfQuestionsForCurr]), @">> (values.count != numberOfQuestionsForCurr) <<");
		cell.button.selected = [[values objectAtIndex:indexPath.row] boolValue];
	}
	
	return cell;
}

/*------------------------------------------------------------------------------------*/
#pragma mark - Notification Methods
/*------------------------------------------------------------------------------------*/

- (void)conciergeSelectedNotification:(NSNotification*)a_notification
{
	NSInteger tag = [[a_notification object] tag];
	BOOL value = ![[_selectedAnswersArray objectAtIndex:tag] boolValue];
	[_selectedAnswersArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:value]];

	if (!sMultiSelectionQuestion[self.currQuestion])
	{
		for (NSInteger index = 0; index < [self numberOfQuestionsForCurr]; index++)
		{
			if (index != [[a_notification object] tag])
			{
				[_selectedAnswersArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
			}
		}
		
		// Post next question notification
		[[NSNotificationCenter defaultCenter] postNotificationName:kConciergeNextNotification object:self userInfo:nil];
	}
	else
	{
		[self saveCurrQuestionState];
		[self updateCurrQuestion];
	}
}

/*------------------------------------------------------------------------------------*/

@end
