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
    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:94.0/255.0 blue:148.0/255.0 alpha:1.0];

    self.titleLabel.textColor = [UIColor whiteColor];

}

@end
