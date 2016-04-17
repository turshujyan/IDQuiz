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
                  difficultyLevel:[NSNumber numberWithInt:(int)(i)/10 + 1]
                       questionId:[NSNumber numberWithInteger: i + 1 ]];
        
        // 1-10 diff.level=1, 11-19 ->2...
        [self saveContext];
    }
}


- (NSArray *)fetchQuestions{
    
    NSArray *array1 = [self getRandomNumbersFrom:1 to :10];
    NSArray *array2 = [self getRandomNumbersFrom:11 to :20];
    NSArray *array3 = [self getRandomNumbersFrom:21 to :30];
    NSArray *array4 = [self getRandomNumbersFrom:31 to :40];
    NSArray *array5 = [self getRandomNumbersFrom:41 to :50];
    
    NSMutableArray *questionNumbers = [[NSMutableArray alloc ]  init];
    [questionNumbers addObjectsFromArray:array1];
    [questionNumbers addObjectsFromArray:array2];
    [questionNumbers addObjectsFromArray:array3];
    [questionNumbers addObjectsFromArray:array4];
    [questionNumbers addObjectsFromArray:array5];
    
    
    NSError *requestError = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityNameQuestion];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(questionId IN %@)", questionNumbers]];
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

- (void)saveResultForUsername:(NSString *)username
                   totalScore:(NSNumber *)score
                    totalTime:(NSNumber *)time {

    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityNameResult];
    [request setPredicate:[NSPredicate predicateWithFormat:@"username = %@" , username]];
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];

    if ([results count] == 0){
        IDQResult *result = [NSEntityDescription insertNewObjectForEntityForName:kEntityNameResult
                                                          inManagedObjectContext:self.managedObjectContext];
        [result setUsername:username
                 totalScore:score
                  totalTime:time];
    } else if ([results count] == 1){
        IDQResult *result = results[0];
        result.totalScore = score;
        result.totalTime = time;
    }
    
    [self saveContext];
}


- (NSArray *)fetchResults {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityNameResult];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    return result;    
}


- (NSArray *)getRandomNumbersFrom:(int)from to:(int)to {
    NSMutableSet *randomNumbers = [[NSMutableSet alloc] init];
    while([randomNumbers count] != 3) {
        [randomNumbers addObject:[NSNumber numberWithInteger:from + arc4random() % (to-from+1)]];
    }
    return [randomNumbers allObjects];
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
