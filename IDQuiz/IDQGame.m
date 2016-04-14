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

-(void)endGame:(IDQResult *)result{
    
    AppDelegate *appDelegate = [UIApplication appDelegate];
    [appDelegate.dataController saveResult:result];
    
    

}

@end
