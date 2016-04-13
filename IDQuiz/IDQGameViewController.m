//
//  IDQGameViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//
#import "AppDelegate.h"
#import "IDQCustomPopup.h"
#import "IDQGameViewController.h"
#import "IDQGame.h"
#import "IDQQuestion.h"


@interface IDQGameViewController ()

@property (nonatomic, strong) IDQGame *game;
@property (nonatomic, strong) IDQQuestion *currentQuestion;


@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation IDQGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [IDQGame sharedGame];
    [self loadQuestion:self.game.questions[0]];
}

- (IBAction)selectAnswer:(UIButton *)sender {
    NSNumber *index = self.currentQuestion.rightAnswerIndex;
    if ([sender.titleLabel.text isEqual:self.currentQuestion.answers[[index intValue]]]) {
        NSInteger nextQuestionNumber = ++self.game.gameState.currentQuestionNumber;
        [self loadQuestion:self.game.questions[nextQuestionNumber]];
    }

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

- (IBAction)removeTwoAnswers:(UIButton *)sender {
    // ARAM, remove random 2 incorrect answers
    UIButton *button =  self.answerButtons[0];
    button.hidden  = YES;
    
}
- (IBAction)showInfoText:(id)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"showInfoText"] isEqualToString:@"available"]) {

        IDQCustomPopup *popup;
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"IDQCustomPopup" owner:self options:nil];
        for (id nib in nibs) {
            if ([nib isKindOfClass:[IDQCustomPopup class]]) {
                popup = nib;
                break;
            }
        }
        popup.frame = CGRectMake(0, 0, 280, 200);
        popup.center = self.view.center;
        popup.infoTextLabel.text = self.currentQuestion.infoText;
        NSLog(@"creating popup %@", self.currentQuestion.infoText);
        [[[UIApplication appDelegate] window] addSubview:popup];
        
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@"used" forKey:@"showInfoText"];
        self.game.gameState.helpOptions = helpOptions;
    }

}
- (IBAction)changeQuestion:(UIButton *)sender {
    if ([[self.game.gameState.helpOptions objectForKey:@"changeQuestion"] isEqualToString:@"available"]) {
        NSNumber *level = self.currentQuestion.difficultyLevel;
        IDQQuestion *newQuestion = [[[UIApplication appDelegate] dataController] fetchQuestionWithDifficultyLevel:level];
        [self loadQuestion:newQuestion];
        NSMutableDictionary *helpOptions = [self.game.gameState.helpOptions mutableCopy];
        [helpOptions setValue:@"used" forKey:@"changeQuestion"];
        self.game.gameState.helpOptions = helpOptions;
    }
}

- (void)popupDidSelectOk:(IDQCustomPopup *)popup {

}

@end
