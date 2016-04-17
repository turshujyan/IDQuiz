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
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (nonatomic, strong) IDQPlayerManager *player;

@end


@implementation IDQGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.game = [IDQGame sharedGame];
    self.player = [IDQPlayerManager sharedPlayer];
    
    [self loadQuestion:self.game.questions[0]];
    self.startDate = [NSDate date];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode: NSDefaultRunLoopMode];
}

- (IBAction)selectAnswer:(UIButton *)sender {
    NSNumber *index = self.currentQuestion.rightAnswerIndex;
    if (![sender.titleLabel.text isEqual:self.currentQuestion.answers[[index intValue]]] ) {
        
        [self endGame];

    } else {
        self.game.gameState.totalScore += 100; // POXEL
        if (self.game.gameState.currentQuestionNumber != 14) {
            NSInteger nextQuestionNumber = ++self.game.gameState.currentQuestionNumber;
            [self loadQuestion:self.game.questions[nextQuestionNumber]];
        } else {
            [self endGame];
        }

    }
}


- (IBAction)removeTwoAnswers:(UIButton *)sender {
    // ARAM, remove random 2 incorrect answers
    UIButton *button =  self.answerButtons[0];
    button.hidden  = YES;
    
}
- (IBAction)showInfoText:(id)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"showInfoText"] isEqualToString:@"available"]) {
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:self.currentQuestion.infoText  message:nil  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@"used" forKey:@"showInfoText"];
        self.game.gameState.helpOptions = helpOptions;
    }
    
}
- (IBAction)changeQuestion:(UIButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"changeQuestion"] isEqualToString:@"available"]) {
        NSNumber *level = self.currentQuestion.difficultyLevel;
        IDQQuestion *newQuestion = [self.game changeQuestionWithDifficultyLevel:level];
        [self loadQuestion:newQuestion];
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@"used" forKey:@"changeQuestion"];
        self.game.gameState.helpOptions = helpOptions;
    }
}


- (IBAction)playMusic:(UIButton *)sender {    
    if ([self.player.audioPlayer isPlaying]) {
        [self.player.audioPlayer pause];
    } else {
        [self.player.audioPlayer play];
        self.player.audioPlayer.currentTime = 0;
    }
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

- (IBAction)openContacts:(UIButton *)sender {
    [self showPeoplePickerController];
}


- (void)loadQuestion:(IDQQuestion *)question{
    self.currentQuestion = question;
    self.questionLabel.text = self.currentQuestion.questionText;
    NSArray *answers = self.currentQuestion.answers;
    
    //ARAM shuffle answers array before setting to buttons
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
    
    [self.player.audioPlayer pause];
    
    self.game.gameState.totalTime = self.totalTimeLabel.text;
    IDQGameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resultsVC"];
    [self presentViewController:vc animated:YES completion:nil];
}

@end