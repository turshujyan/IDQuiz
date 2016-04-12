//
//  User.h
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IDQUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger bestScore;
@property (nonatomic, assign) CGFloat totalTime;


@end


