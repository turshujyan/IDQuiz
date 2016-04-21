//
//  IDQCustomPopupView.m
//  IDQuiz
//
//  Created by Hermine on 4/20/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQCustomPopup.h"
#import "IDQGame.h"

@interface IDQCustomPopup()

@end


@implementation IDQCustomPopup

- (IBAction)okAction:(id)sender {
    
}

- (void)awakeFromNib {
    NSLog(@"%@", self.infoTextLabel.text);
    //IDQGame *game = [IDQGame sharedGame];
    
}

@end
