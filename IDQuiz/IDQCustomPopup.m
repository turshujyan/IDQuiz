//
//  InfoTextView.m
//  IDQuiz
//
//  Created by Hermine on 4/13/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQCustomPopup.h"

@implementation IDQCustomPopup


-(void)awakeFromNib {
    NSLog(@"IDQCustomPopup");
    self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:178.0/255.0 alpha:1.0];

}
- (IBAction)ok:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
