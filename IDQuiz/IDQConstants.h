//
//  IDQConstants.m
//  IDQuiz
//
//  Created by Hermine on 4/10/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kEntityNameQuestion = @"Question";
static NSString *const kEntityNameResult = @"Result";
static NSInteger const kQuestionTime = 30;
//static NSArray *questionScores = @[@100, @200, @300, @400, @500]
typedef enum {
    RemoveTwoIncorrectAnswers,
    ChangeQuestion,
    PasswordsDoNotMatchWarning,
    UsernameInUseWarning,
} HelpOption;



