//
//  Result.m
//  IDQuiz
//
//  Created by Hermine on 4/14/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQResult.h"

@implementation IDQResult

@dynamic totalScore;
@dynamic totalTime;
@dynamic username;

- (void)setUsername:(NSString *)username
         totalScore:(NSNumber *)score
          totalTime:(NSNumber *)time {
    self.username = username;
    self.totalScore = score;
    self.totalTime = time;
}


@end
