//
//  IDQGameState.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQGameState.h"

@implementation IDQGameState

-(id)init {
    
    self = [super init];
    if (self) {
        self.currentQuestionNumber = 0;
        self.totalTime = 0;
        self.totalScore = 0;
        NSArray *helpersNamesArray = @[@"removeTwoAnswers", @"changeQuestion", @"call", @"allowIncorrectAnswer"];
        NSArray *helpersValuesArray = @[@YES, @YES, @YES, @YES];
        self.helpOptions = [[NSDictionary alloc] initWithObjects:helpersValuesArray forKeys:helpersNamesArray];
    }
    return self;
}


@end
