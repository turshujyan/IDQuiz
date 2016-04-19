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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface IDQGameViewController () < ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,
ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>

@property (nonatomic, assign) CNContactStore *addressBook;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) IDQGame *game;
@property (nonatomic, strong) IDQQuestion *currentQuestion;
@property (nonatomic, strong) IDQPlayerManager *player;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;


@end


@implementation IDQGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [IDQGame sharedGame];
    [self loadQuestion:self.game.questions[0]];
    self.startDate = [NSDate date];
    self.player = [IDQPlayerManager sharedPlayer];

    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
    
    self.questionLabel.layer.masksToBounds = YES;
    self.questionLabel.layer.cornerRadius = 4;
   // self.questionLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    //self.questionLabel.layer.borderWidth = 2.0;

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.player.audioPlayer pause];
    self.player.audioPlayer.currentTime = 0;

}

- (IBAction)selectAnswer:(IDQButton *)sender {
    NSNumber *index = self.currentQuestion.rightAnswerIndex;
    if (![sender.titleLabel.text isEqual:self.currentQuestion.answers[[index intValue]]] ) {
        [self endGame];
    } else {
        
        
        self.game.gameState.totalScore += 100; // POXEL
        if (self.game.gameState.currentQuestionNumber != 14) {
            NSInteger nextQuestionNumber = ++self.game.gameState.currentQuestionNumber;
            [self loadQuestion:self.game.questions[nextQuestionNumber]];
            self.totalScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.game.gameState.totalScore];
        } else {
            [self endGame];
        }
    }
}


- (IBAction)removeTwoAnswers:(UIButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"50/50"] isEqualToString:@"available"]) {
        NSInteger index1, index2;
        do {
            index1 = arc4random() % 4;
        } while (index1 == [self.currentQuestion.rightAnswerIndex integerValue]);
        [self.answerButtons[index1] setHidden:YES];
        
        do {
            index2 = arc4random() % 4;
        } while (index2 == index1 || index2 == [self.currentQuestion.rightAnswerIndex integerValue]);
        [self.answerButtons[index2] setHidden:YES];
        
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@"used" forKey:@"50/50"];
        self.game.gameState.helpOptions = helpOptions;
        [sender setEnabled:NO];
    }
}

- (IBAction)showInfoText:(IDQButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"showInfoText"] isEqualToString:@"available"]) {
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:self.currentQuestion.infoText  message:nil  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@"used" forKey:@"showInfoText"];
        self.game.gameState.helpOptions = helpOptions;
        [sender setEnabled:NO];
    }
    
}
- (IBAction)changeQuestion:(IDQButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"changeQuestion"] isEqualToString:@"available"]) {
        NSNumber *level = self.currentQuestion.difficultyLevel;
        IDQQuestion *newQuestion = [self.game changeQuestionWithDifficultyLevel:level];
        [self loadQuestion:newQuestion];
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@"used" forKey:@"changeQuestion"];
        self.game.gameState.helpOptions = helpOptions;
        [sender setEnabled:NO];
    }
}


- (IBAction)playMusic:(IDQButton *)sender {
    IDQPlayerManager *player = [IDQPlayerManager sharedPlayer];
    if ([player.audioPlayer isPlaying]) {
        [player.audioPlayer pause];
        [sender setBackgroundImage:[UIImage imageNamed:@"music_off"] forState:UIControlStateNormal];
       // sender.alpha = 0.5;
    } else {
        [player.audioPlayer play];
        [sender setBackgroundImage:[UIImage imageNamed:@"music.png"] forState:UIControlStateNormal];

    }
}
- (IBAction)changeSoundSetting:(IDQButton *)sender {
    
}

- (IBAction)openContacts:(IDQButton *)sender {
    [self showPeoplePickerController];
    [sender setEnabled:NO];
}


- (void)loadQuestion:(IDQQuestion *)question{
    self.currentQuestion = question;
    self.questionLabel.text = self.currentQuestion.questionText;
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld of 15", (long)self.game.gameState.currentQuestionNumber + 1];
    NSMutableArray *answers = [NSMutableArray arrayWithArray:self.currentQuestion.answers];
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
        button.hidden = NO;
        [button setTitle:answers[i] forState:UIControlStateNormal];
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

- (void)endGame {
    self.game.gameState.totalTime = self.totalTimeLabel.text;
    [self.timer invalidate];
    IDQGameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resultsVC"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)showPeoplePickerController {
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
    
    
    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end