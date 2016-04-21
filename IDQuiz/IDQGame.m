//
//  IDQGame.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQGame.h"
#import "IDQDataController.h"
#import "AppDelegate.h"

@implementation IDQGame

+ (instancetype)sharedGame {
    static IDQGame *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[IDQGame alloc] init];
    });
    return instance;
}

- (void)startNewGame {
    AppDelegate *appDelegate = [UIApplication appDelegate];
    self.questions = [appDelegate.dataController fetchQuestions];
    self.gameState = [[IDQGameState alloc] init];
}

- (IDQQuestion *)changeQuestionWithDifficultyLevel:(NSNumber *)difficultyLevel {
    AppDelegate *appDelegate = [UIApplication appDelegate];
    return  [appDelegate.dataController fetchQuestionWithDifficultyLevel:difficultyLevel];
}

- (void)endGameForUser:(NSString *)username {
    NSArray *components = [self.gameState.totalTime componentsSeparatedByString:@":"];
    NSInteger totalTimeInSeconds = 60 * [components[0] integerValue] + [components[1] integerValue];
    AppDelegate *appDelegate = [UIApplication appDelegate];
    [appDelegate.dataController saveResultForUsername:username
                                           totalScore:[NSNumber numberWithInteger:self.gameState.totalScore]
                                            totalTime:[NSNumber numberWithInteger:totalTimeInSeconds]];
    
}

@end
