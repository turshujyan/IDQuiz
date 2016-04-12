//
//  IDQQuestion.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQQuestion.h"

@implementation IDQQuestion
- (id) initWithQuestionText:(NSString *)questionText answers:(NSArray *)answers rightAnswer:(NSString *)rightAnswer infoText:(NSString *)infoText category:(NSString *)category {
    self = [super init];
    if(self) {
        self.questionText = questionText;
        self.answers = answers;
        self.rightAnswer = rightAnswer;
        self.infoText = infoText;
        self.category = category;
        
        
    
    }
    return self;
}

@end
