//
//  IDQDataController.m
//  IDQuiz
//
//  Created by Hermine on 4/10/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQDataController.h"
#import "AppDelegate.h"

@interface IDQDataController()

@property NSArray *questionIds;
@end


@implementation IDQDataController

+ (instancetype)sharedDataController {
    static IDQDataController *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[IDQDataController alloc] init];
    });
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if(![defaults objectForKey:@"questionsAdded"]) {
            [self writeQuestionsToDB];
            [defaults setObject:@"YES" forKey:@"questionsAdded"];
        }
        
    }
    return self;
}


- (void)writeQuestionsToDB {
    
    for (NSInteger i = 0; i <= 49; i++) {
        
        IDQQuestion *question = [NSEntityDescription insertNewObjectForEntityForName:kEntityNameQuestion
                                                              inManagedObjectContext:self.managedObjectContext];
        
        NSInteger righAnswerIndex = arc4random()%4;
        NSString *answerText = [NSString stringWithFormat:@"Q %ld answer", i+1 ];
        NSMutableArray *answersArray = [[NSMutableArray alloc] initWithObjects: answerText, answerText, answerText, answerText, nil];
        [answersArray setObject:@"rightAnswer" atIndexedSubscript:righAnswerIndex];
        
        [question setQuestionText:[NSString stringWithFormat:@"Question %ld text", (long)i+1]
                          answers:answersArray
                 rightAnswerIndex:[NSNumber numberWithInteger:righAnswerIndex]
                         infoText:[NSString stringWithFormat:@"Info text for question %ld", (long)i+1]
                     categoryName:[NSString stringWithFormat:@"Category %u", arc4random()%15]
                  difficultyLevel:[NSNumber numberWithLong:(i%5 + 1)]
                       questionId:[NSNumber numberWithInteger:i+1]];
        [self saveContext];
    }
}


- (NSArray *)fetchQuestions{
    NSError *requestError = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityNameQuestion];
    [request setFetchLimit:15];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    NSMutableArray *questionIds = [[NSMutableArray alloc] initWithCapacity:result.count];
    
    if(!requestError) {
        for(IDQQuestion *question in result) {
            [questionIds addObject:question.questionId];
        }
        self.questionIds = [questionIds copy];
        return result;
    } else {
        return nil;
        
    }
}


- (IDQQuestion *)fetchQuestionWithDifficultyLevel:(NSNumber *)level{
    
    NSError *requestError = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityNameQuestion];
    [request setPredicate:[NSPredicate predicateWithFormat:@"difficultyLevel = %@  AND  NOT (questionId IN %@)", level, self.questionIds]];
    NSArray *result= [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if(!requestError) {
        return result[0];
    } else {
        return nil;
    }
}

- (void)saveResult:(IDQResult *)result {

}

#pragma mark - CORE DATA

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "AM.AMProgrammerTest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IDQuiz" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IDQuiz.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
