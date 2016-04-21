//
//  IDQGameViewController.h
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IDQPlayerManager.h"
#import "JSKTimerView.h"

@interface IDQGameViewController : UIViewController

@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet JSKTimerView *timerView;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;

-(void)showPeoplePickerController;


@end