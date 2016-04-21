//
//  IDQButton.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQButton.h"
#import <AudioToolBox/AudioToolBox.h>

static BOOL soundFX;

@implementation IDQButton

- (void)awakeFromNib {
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 4;
   // self.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:94.0/255.0 blue:148.0/255.0 alpha:1.0];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchUpInside];
    soundFX = YES;
    
}

- (void)playSound {
    
    static SystemSoundID sound;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSLog(@"token");
        NSString *soundPath = [NSString stringWithFormat:@"%@/buttonSound.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound);
    });
    
    if (soundFX) {
        AudioServicesPlaySystemSound(sound);
    }
}

- (void)changeSoundSetting {
    if (soundFX) {
        soundFX = NO;
    } else {
        soundFX = YES;
    }
}


@end


