//
//  IDQQuestion.h
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDQQuestion : NSObject

@property (nonatomic,strong) NSString *questionText;
@property (nonatomic,strong) NSArray *answers;
@property (nonatomic,strong) NSString *rightAnswer;
@property (nonatomic,strong) NSString *infoText;
@property (nonatomic,strong) NSString *category;

- (id) initWithQuestionText:(NSString *)questionText answers:(NSArray *)answers rightAnswer:(NSString *)rightAnswer infoText:(NSString *)infoText category:(NSString *)category;



@end
