//
//  IDQQuestion.m
//  IDQuiz
//
//  Created by Hermine on 4/10/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQQuestion.h"

@implementation IDQQuestion

@dynamic questionId;
@dynamic answers;
@dynamic questionText;
@dynamic rightAnswerIndex;
@dynamic difficultyLevel;

- (void)setQuestionText:(NSString *)questionText
                 answers:(NSArray *)answers
        rightAnswerIndex:(NSNumber *)rightAnswer
         difficultyLevel:(NSNumber *)difficultyLevel
              questionId:(NSNumber *)questionId{
    self.questionText = questionText;
    self.answers = answers;
    self.rightAnswerIndex = rightAnswer;
    self.difficultyLevel = difficultyLevel;
    self.questionId = questionId;
}

@end
