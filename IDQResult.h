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

@property (nullable, nonatomic, retain) NSNumber *bestScore;
@property (nullable, nonatomic, retain) NSString *bestTime;
@property (nullable, nonatomic, retain) NSString *username;

@end
