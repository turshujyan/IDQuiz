//
//  IDQAnswerButton.m
//  IDQuiz
//
//  Created by Hermine on 4/18/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQAnswerButton.h"

@implementation IDQAnswerButton

- (void)awakeFromNib {
    [super awakeFromNib];
   // self.layer.cornerRadius = 55; //colorWithRed:12.0/255.0 green:94.0/255.0 blue:148.0/255.0 alpha:1.0
   // self.layer.borderColor = [[UIColor whiteColor] CGColor];
  //  self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = 4;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

@end
