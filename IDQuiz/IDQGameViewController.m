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
#import "IDQHelperButton.h"
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
@property (nonatomic, assign) BOOL allowIncorrectAnswerSelected;


@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (nonatomic, strong) IBOutletCollection(IDQHelperButton) NSArray *helperButtons;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (weak, nonatomic) IBOutlet IDQButton *musicButton;
@property (weak, nonatomic) IBOutlet IDQButton *soundButton;
@property (weak, nonatomic) IBOutlet JSKTimerView *timerView;

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
            
            if(self.allowIncorrectAnswerSelected) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self changeBackgroundForButton:(selectedButtonIndex) withColor:@"blue"];
                    for (UIButton *button in self.answerButtons) {
                        button.userInteractionEnabled = YES;
                        self.allowIncorrectAnswerSelected = NO;
                        [self.timerView startTimer];
                    }
                });
            
            } else {
            
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
            }
        } else {
            [self.playerManager playWinSound];
            self.allowIncorrectAnswerSelected = NO;
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
    if ([[self.game.gameState.helpOptions objectForKey:@"removeTwoAnswers"] isEqual:@YES]) {
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
        [helpOptions setValue:@NO forKey:@"removeTwoAnswers"];
        self.game.gameState.helpOptions = helpOptions;
        [sender setEnabled:NO];
    }
}




- (IBAction)openContacts:(IDQButton *)sender {
    
    [self showPeoplePickerController];
    [sender setEnabled:NO];
    [self.timerView pauseTimer];
    
}
- (IBAction)changeQuestion:(UIButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"changeQuestion"] isEqual:@YES]) {
        NSNumber *level = self.currentQuestion.difficultyLevel;
        IDQQuestion *newQuestion = [self.game changeQuestionWithDifficultyLevel:level];
        [self loadQuestion:newQuestion];
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@NO forKey:@"changeQuestion"];
        self.game.gameState.helpOptions = helpOptions;
        [sender setEnabled:NO];
        [self.timerView resetTimer];
        [self.timerView startTimer];
    }
}

- (IBAction)allowIncorrectAnswer:(UIButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"allowIncorrectAnswer"] isEqual:@YES]) {
        self.allowIncorrectAnswerSelected = YES;
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@NO forKey:@"allowIncorrectAnswer"];
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



#pragma mark other private methods

- (void)resetButtonBackgrounds {
    for (NSInteger i = 0; i < self.answerButtons.count; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"answer%lu-blue",i + 1 ];
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

//Timer delegate methods
- (void)timerDidFinish:(JSKTimerView *)timerView {
    [self endGame];
}
- (void)timerChangedStateToRed:(JSKTimerView *)timerView {
    for (IDQHelperButton *button in self.helperButtons) {
        button.backgroundColor = [UIColor redColor];
    }
}
- (void)timerChangedStateToYellow:(JSKTimerView *)timerView {
    for (IDQHelperButton *button in self.helperButtons) {
        button.backgroundColor = [UIColor colorWithRed:1.0 green:204/255.0 blue:51/255.0 alpha:1.0];
    }
}


- (void)endGame {
    self.game.gameState.totalTime = self.totalTimeLabel.text;
    [self.timer invalidate];
    IDQGameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resultsVC"];
    [self presentViewController:vc animated:YES completion:nil];
}


@end