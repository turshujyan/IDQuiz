//
//  IDQGame.h
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDQGameState.h"
#import "IDQResult.h"
#import "IDQQuestion.h"


@interface IDQGame : NSObject

@property (nonatomic, strong) IDQGameState *gameState;
@property (nonatomic, strong) NSArray *questions;

+ (instancetype)sharedGame;
- (void)startNewGame;
- (IDQQuestion *)changeQuestionWithDifficultyLevel:(NSNumber *)difficultyLevel;
- (void)endGameForUser:(NSString *)username;
- (void)getLeaderBoard;
@end
