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
@property (nonatomic, assign) NSNumber *rightAnswerIndex;
@property (nonatomic, retain) NSString *infoText;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, assign) NSNumber *difficultyLevel;

- (void)setQuestionText:(NSString *)questionText
                 answers:(NSArray *)answers
       rightAnswerIndex:(NSNumber *)rightAnswer
               infoText:(NSString *)infoText
                categoryName:(NSString *)categoryName
         difficultyLevel:(NSNumber *)difficultyLevel;

@end

