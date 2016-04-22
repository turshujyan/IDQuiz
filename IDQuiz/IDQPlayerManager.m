//
//  IDQPlayerManager.m
//  IDQuiz
//
//  Created by Arman Markosyan on 4/13/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQPlayerManager.h"

@implementation IDQPlayerManager

+ (instancetype)sharedPlayer {
    static IDQPlayerManager *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[IDQPlayerManager alloc] init];
        [instance initAudioPlayer];
    });
    return instance;
}

- (void)initAudioPlayer {
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getMusicURL] error:nil];
    self.audioPlayer.numberOfLoops = -1;
}

- (NSURL *)getMusicURL {
    NSString *path = [NSString stringWithFormat:@"%@/redbone.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *musicURL = [NSURL fileURLWithPath:path];
    return musicURL;
}


- (void)playWinSound {
    
    static SystemSoundID sound;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *soundPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Win.wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound);
    });
    
    AudioServicesPlaySystemSound(sound);

  //  [self playSoundByName:@"Win.wav"];
}

- (void)playLoseSound {
    static SystemSoundID sound;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *soundPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Lose.wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound);
    });
    
    AudioServicesPlaySystemSound(sound);
    //[self playMusicByName:@"Lose.wav"];
}




@end
