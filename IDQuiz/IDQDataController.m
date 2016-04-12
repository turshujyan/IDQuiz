//
//  IDQDataController.m
//  IDQuiz
//
//  Created by Hermine on 4/10/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQDataController.h"
#import "AppDelegate.h"

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
//        [self writeQuestionsToDB];

    }
    return self;
}


- (void) writeQuestionsToDB {
    IDQQuestion *question = [NSEntityDescription insertNewObjectForEntityForName:kEntityNameQuestion
                                                          inManagedObjectContext:self.managedObjectContext];
    [question setQuestionText:@"Question 6 text"
                      answers:@[@"answer", @"answer", @"answer", @"rightAnswer"]
                  rightAnswer:@"rightAnswer"
                     infoText:@"info text for question 6"
                     category:@"Category4"
              difficultyLevel:@4];
    
    [self saveContext];
}


- (NSArray *)fetchQuestions{
    
    NSError *requestError = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityNameQuestion];
    //[request setPredicate:[NSPredicate predicateWithFormat:@"category = 'Category1'"]];
    return [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
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
