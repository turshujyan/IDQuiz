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
    self.layer.cornerRadius = 4;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

@end
