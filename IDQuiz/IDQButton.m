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
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 2;
    
    [self addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"soundOn"] && [userDefaults boolForKey:@"soundOn"]) {
        soundFX = YES;
    } else {
        soundFX = NO;
    }
}

- (void)playSound {
    if (soundFX) {
        static SystemSoundID sound;
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            NSString *soundPath = [NSString stringWithFormat:@"%@/buttonSound.wav", [[NSBundle mainBundle] resourcePath]];
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound);
        });
        AudioServicesPlaySystemSound(sound);
    }
}

- (void)changeSoundSetting {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (soundFX) {
        soundFX = NO;
        [userDefaults setBool:NO forKey:@"soundOn"];
    } else {
        soundFX = YES;
        [userDefaults setBool:YES forKey:@"soundOn"];
    }
}


@end


