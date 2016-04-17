//
//  Result.h
//  IDQuiz
//
//  Created by Hermine on 4/14/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IDQResult : NSManagedObject

@property (nonatomic, retain) NSNumber *totalScore;
@property (nonatomic, retain) NSNumber *totalTime;
@property (nonatomic, retain) NSString *username;

- (void)setUsername:(NSString *)username
         totalScore:(NSNumber *)score
          totalTime:(NSNumber *)time;
@end
