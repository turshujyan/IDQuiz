//
//  IDQGameViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//
#import "AppDelegate.h"
#import "IDQGameViewController.h"
#import "IDQGame.h"
#import "IDQQuestion.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


@interface IDQGameViewController () <CNContactPickerDelegate, JSKTimerViewDelegate>

@property (nonatomic, assign) CNContactStore *addressBook;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) IDQGame *game;
@property (nonatomic, strong) IDQQuestion *currentQuestion;
@property (nonatomic, strong) IDQPlayerManager *playerManager;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *helperButtons;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (weak, nonatomic) IBOutlet IDQButton *musicButton;
@property (weak, nonatomic) IBOutlet IDQButton *soundButton;

@end


@implementation IDQGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Loading question
    self.game = [IDQGame sharedGame];
    [self loadQuestion:self.game.questions[0]];
    
    //Music/sound settings
    self.playerManager = [IDQPlayerManager sharedPlayer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"musicOn"] || ([userDefaults objectForKey:@"musicOn"] && [userDefaults boolForKey:@"musicOn"])) {     //if view is loaded first time or play music setting in on
        [self.playerManager.audioPlayer play];
    } else {
        [self.musicButton setBackgroundImage:[UIImage imageNamed:@"musicOff"] forState:UIControlStateNormal];
    };
    
    if (![userDefaults boolForKey:@"soundOn"]) {
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"soundOff"] forState:UIControlStateNormal];
    };
    
    
    //Question timer
    [self.timerView startTimerWithDuration:30];
    self.timerView.labelTextColor = [UIColor whiteColor];
    [self.timerView setDelegate:self];

    
    //Total timer
    self.startDate = [NSDate date];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
    
    //UI settings
    self.questionLabel.layer.masksToBounds = YES;
    self.questionLabel.layer.cornerRadius = 4;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerManager.audioPlayer stop];
    self.playerManager.audioPlayer.currentTime = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark - IBACTIONS

- (IBAction)selectAnswer:(IDQButton *)sender {
    NSUInteger selectedButtonIndex = [self.answerButtons indexOfObject:sender];
    [self.timerView pauseTimer];
    [self changeBackgroundForButton:(selectedButtonIndex) withColor:@"orange"];
    for (UIButton *button in self.answerButtons) {
            button.userInteractionEnabled = NO;
    }
    for (UIButton *button in self.helperButtons) {
        button.userInteractionEnabled = NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        NSNumber *rightAnswerIndex = self.currentQuestion.rightAnswerIndex;
        if (![sender.titleLabel.text isEqualToString:self.currentQuestion.answers[[rightAnswerIndex intValue]]]) {
            [self changeBackgroundForButton:(selectedButtonIndex) withColor:@"red"];
            NSString *rightAnswerTitle = self.currentQuestion.answers[[rightAnswerIndex intValue]];
            for (NSInteger i = 0; i < self.answerButtons.count; ++i) {
                if ([[self.answerButtons[i] titleLabel].text isEqualToString:rightAnswerTitle]) {
                    [self changeBackgroundForButton:i withColor:@"green"];
                    break;
                }
            }
            [self.playerManager playLoseSound];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self endGame];
            });
        } else {
            [self.playerManager playWinSound];

            NSUInteger selectedButtonIndex = [self.answerButtons indexOfObject:sender];
            [self changeBackgroundForButton:selectedButtonIndex withColor:@"green"];
            [self addScoreForQuestion:self.game.gameState.currentQuestionNumber];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if (self.game.gameState.currentQuestionNumber != 14) {
                    NSInteger nextQuestionNumber = ++self.game.gameState.currentQuestionNumber;
                    [self loadQuestion:self.game.questions[nextQuestionNumber]];
                    self.totalScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.game.gameState.totalScore];
                    [self.timerView resetTimer];
                    [self.timerView startTimer];


                } else {
                    [self endGame];
                }
            });
           
        }
    });
}

- (IBAction)removeTwoAnswers:(UIButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"50/50"] isEqual:@YES]) {
        UIButton *button;
        NSString *rightAnswer = self.currentQuestion.answers[[self.currentQuestion.rightAnswerIndex integerValue]];
        NSInteger index1, index2;
        do {
            index1 = arc4random() % 4;
            button = self.answerButtons[index1];
        } while ([button.titleLabel.text isEqualToString:rightAnswer]);
        [self.answerButtons[index1] setHidden:YES];
        do {
            index2 = arc4random() % 4;
            button = self.answerButtons[index2];
        } while (index2 == index1 || [button.titleLabel.text isEqualToString:rightAnswer]);
        [self.answerButtons[index2] setHidden:YES];
        
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@NO forKey:@"50/50"];
        self.game.gameState.helpOptions = helpOptions;
        [sender setEnabled:NO];
    }
}


- (IBAction)showInfoText:(IDQButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"showInfoText"] isEqual:@YES]) {
        
       UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:self.currentQuestion.infoText  message:nil  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
      
    }
     NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
     [helpOptions setValue:@NO forKey:@"showInfoText"];
     self.game.gameState.helpOptions = helpOptions;
     [sender setEnabled:NO];

    
}

- (IBAction)changeQuestion:(IDQButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"changeQuestion"] isEqual:@YES]) {
        NSNumber *level = self.currentQuestion.difficultyLevel;
        IDQQuestion *newQuestion = [self.game changeQuestionWithDifficultyLevel:level];
        [self loadQuestion:newQuestion];
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@NO forKey:@"changeQuestion"];
        self.game.gameState.helpOptions = helpOptions;
        [sender setEnabled:NO];
    }
}

- (IBAction)backToHome:(IDQButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeMusicSetting:(IDQButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.playerManager.audioPlayer isPlaying]) {
        [self.playerManager.audioPlayer pause];
        [sender setBackgroundImage:[UIImage imageNamed:@"musicOff"] forState:UIControlStateNormal];
        [userDefaults setBool:NO forKey:@"musicOn"];
    } else {
        [self.playerManager.audioPlayer play];
        [sender setBackgroundImage:[UIImage imageNamed:@"musicOn.png"] forState:UIControlStateNormal];
        [userDefaults setBool:YES forKey:@"musicOn"];
    }
}

- (IBAction)changeSoundSetting:(IDQButton *)sender {
    [sender changeSoundSetting];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"soundOn"]) {
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"soundOff"] forState:UIControlStateNormal];
    } else {
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"soundOn"] forState:UIControlStateNormal];
    }
}

- (IBAction)openContacts:(IDQButton *)sender {
    
    [self showPeoplePickerController];
    [sender setEnabled:NO];
    [self.timerView pauseTimer];
    
}

#pragma mark other private methods

- (void)resetButtonBackgrounds {
    for (NSInteger i = 0; i < self.answerButtons.count; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"answer%lu",i + 1 ];
        UIImage *newImage = [UIImage imageNamed:imageName];
        [self.answerButtons[i] setBackgroundImage:newImage forState:UIControlStateNormal];
    }
}

- (void)loadQuestion:(IDQQuestion *)question{
    [self resetButtonBackgrounds];
    self.currentQuestion = question;
    self.questionLabel.text = self.currentQuestion.questionText;
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld of 15", (long)self.game.gameState.currentQuestionNumber + 1];
    
    NSMutableArray *answers = [NSMutableArray arrayWithArray:self.currentQuestion.answers];
    
    //shuffling array
    NSInteger index;
    id temp;
    for (NSInteger i = 0; i < answers.count; ++i) {
        index = arc4random() % (answers.count - i) + i;
        temp = answers[i];
        answers[i] = answers[index];
        answers[index] = temp;
    }
    
    for (NSInteger i = 0; i <  answers.count; i++) {
        UIButton *button =  self.answerButtons[i];
        button.userInteractionEnabled = YES;
        button.hidden = NO;
        [button setEnabled:YES];
        [button setTitle:answers[i] forState:UIControlStateNormal];
    }
    for (UIButton *button in self.helperButtons) {
        button.userInteractionEnabled = YES;
    }

}

- (void)timeTick:(NSTimer *)timer {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    self.totalTimeLabel.text = timeString;
}

- (void)timerDidFinish:(JSKTimerView *)timerView {
    [self endGame];
}

- (void)endGame {
    self.game.gameState.totalTime = self.totalTimeLabel.text;
    [self.timer invalidate];
    IDQGameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resultsVC"];
    [self presentViewController:vc animated:YES completion:nil];
    

}

- (void)showPeoplePickerController {
    
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    
    picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    [self presentViewController:picker animated:YES completion:nil];
    
    }

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicOn"]) {
        [self.playerManager.audioPlayer play];
    }
    
    [self.timerView startTimer];
}

- (void)changeBackgroundForButton:(NSInteger)index withColor:(NSString *)color {
    NSString *imageName = [NSString stringWithFormat:@"answer%lu-%@",index + 1, color];
    UIImage *newImage = [UIImage imageNamed:imageName];
    [self.answerButtons[index] setBackgroundImage:newImage forState:UIControlStateNormal];
}

- (void)addScoreForQuestion:(NSInteger)questionNumber {
    self.game.gameState.totalScore += (questionNumber + 1) * 100;
}


@end