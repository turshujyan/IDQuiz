//
//  IDQHelperButton.m
//  IDQuiz
//
//  Created by Hermine on 4/23/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQHelperButton.h"

@implementation IDQHelperButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib {

    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor colorWithRed:101/255.0 green:188/255.0 blue:85/255.0 alpha:1.0];


}

@end
