//
//  IDQDataController.h
//  IDQuiz
//
//  Created by Hermine on 4/10/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IDQQuestion.h"
#import "IDQConstants.h"
#import "IDQResult.h"


@interface IDQDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedDataController;
- (NSArray *)fetchQuestions;
- (NSArray *)fetchResults;
- (IDQQuestion *)fetchQuestionWithDifficultyLevel:(NSNumber *)difficultyLevel;
- (void)saveResultForUsername:(NSString *)username
                   totalScore:(NSNumber *)score
                    totalTime:(NSNumber *)time;

@end
