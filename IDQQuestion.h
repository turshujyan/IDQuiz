//
//  IDQQuestion.h
//  IDQuiz
//
//  Created by Hermine on 4/10/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IDQQuestion : NSManagedObject

@property (nonatomic, retain) NSString *questionText;
@property (nonatomic, retain) NSArray *answers;
@property (nonatomic, retain) NSString *rightAnswer;
@property (nonatomic, retain) NSString *infoText;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSNumber *difficultyLevel;

- (void) setQuestionText:(NSString *)questionText answers:(NSArray *)answers rightAnswer:(NSString *)rightAnswer infoText:(NSString *)infoText category:(NSString *)category difficultyLevel:(NSNumber *)difficultyLevel;

@end

