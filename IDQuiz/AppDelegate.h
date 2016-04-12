//
//  AppDelegate.h
//  IDQuiz
//
//  Created by Hermine on 4/8/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "IDQDataController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IDQDataController *dataController;

@end

