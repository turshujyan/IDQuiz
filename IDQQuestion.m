//
//  IDQQuestion.m
//  IDQuiz
//
//  Created by Hermine on 4/10/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQQuestion.h"

@implementation IDQQuestion

@dynamic answers;
@dynamic category;
@dynamic infoText;
@dynamic questionText;
@dynamic rightAnswer;
@dynamic difficultyLevel;

- (void) setQuestionText:(NSString *)questionText answers:(NSArray *)answers rightAnswer:(NSString *)rightAnswer infoText:(NSString *)infoText category:(NSString *)category difficultyLevel:(NSNumber *)difficultyLevel {
    self.questionText = questionText;
    self.answers = answers;
    self.rightAnswer = rightAnswer;
    self.infoText = infoText;
    self.category = category;
    self.difficultyLevel = difficultyLevel;
}

@end
