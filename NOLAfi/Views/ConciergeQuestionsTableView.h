/*------------------------------------------------------------------------------------*/
//
//  ConciergeQuestionsTableView.h
//  iNewOrleans
//
//  Created by Jonathan Morin on 4/21/13.
//  Copyright (c) 2013 Jonathan Morin. All rights reserved.
//
/*------------------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>

/*------------------------------------------------------------------------------------*/

enum {
	kQuestionGender = 0,
	kQuestionAge,
	kQuestionExperience,
	kQuestionWhen,
	kQuestionActivities,
	kQuestionFood,
	kQuestionMusic,
	kQuestionAccommodations,
	
	// Keep this at the bottom
	kNumQuestions,
};

/*------------------------------------------------------------------------------------*/

@interface ConciergeQuestionsTableView : UITableView

/*------------------------------------------------------------------------------------*/

@property (nonatomic, weak) UILabel * questionLabel;
@property (nonatomic, weak) UILabel * questionCountLabel;

@property (nonatomic, assign) NSInteger currQuestion;

/*------------------------------------------------------------------------------------*/

- (BOOL)nextQuestion;
- (BOOL)prevQuestion;

+ (NSInteger)numberOfQuestionsForIndex:(NSInteger)a_index;
+ (NSString*)questionsKeyForIndex:(NSInteger)a_index;
+ (NSString*)questionForIndex:(NSInteger)a_index;
+ (NSString*)questionKeywordForIndex:(NSInteger)a_index;
+ (NSString*)answerForQuestion:(NSInteger)a_questionIndex subIndex:(NSInteger)a_answerIndex;

/*------------------------------------------------------------------------------------*/

@end
