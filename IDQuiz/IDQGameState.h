//
//  IDQGameState.h
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IDQGameState : NSObject

@property (nonatomic, assign) NSInteger currentQuestionNumber;
@property (nonatomic, strong) NSDictionary *helpOptions;
@property (nonatomic, assign) NSInteger totalScore;
@property (nonatomic, assign) CGFloat totalTime;

-(id)init; 

@end
