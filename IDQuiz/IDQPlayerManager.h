//
//  IDQPlayerManager.h
//  IDQuiz
//
//  Created by Arman Markosyan on 4/13/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h> // porcel AVAudioPlayer

@interface IDQPlayerManager : NSObject

@property (nonatomic,retain) AVAudioPlayer *audioPlayer;


+ (instancetype)sharedPlayer;

@end
