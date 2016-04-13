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
@dynamic categoryName;
@dynamic infoText;
@dynamic questionText;
@dynamic rightAnswerIndex;
@dynamic difficultyLevel;

- (void) setQuestionText:(NSString *)questionText
                 answers:(NSArray *)answers
        rightAnswerIndex:(NSNumber *)rightAnswer
                infoText:(NSString *)infoText
            categoryName:(NSString *)categoryName
         difficultyLevel:(NSNumber *)difficultyLevel {
    self.questionText = questionText;
    self.answers = answers;
    self.rightAnswerIndex = rightAnswer;
    self.infoText = infoText;
    self.categoryName = categoryName;
    self.difficultyLevel = difficultyLevel;
}

@end
