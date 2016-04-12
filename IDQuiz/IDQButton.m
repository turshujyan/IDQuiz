//
//  IDQButton.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQButton.h"

@implementation IDQButton

- (void)awakeFromNib {
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 6;
    self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:175.0/255.0 blue:178.0/255.0 alpha:1.0];
    self.titleLabel.textColor = [UIColor whiteColor];

}

@end
