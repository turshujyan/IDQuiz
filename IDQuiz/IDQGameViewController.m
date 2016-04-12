//
//  IDQGameViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQGameViewController.h"
#import "IDQGame.h"
#import "IDQQuestion.h"


@interface IDQGameViewController ()
@property (nonatomic, strong) IDQGame *game;
@property (nonatomic, strong) IDQQuestion *currentQuestion;


@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
/*@property (weak, nonatomic) IBOutlet UIButton *answerOne;
@property (weak, nonatomic) IBOutlet UIButton *answerTwo;
@property (weak, nonatomic) IBOutlet UIButton *answerThree;
@property (weak, nonatomic) IBOutlet UIButton *answerFour;*/
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation IDQGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [IDQGame sharedGame];
    [self loadQuestion:0];
}

- (IBAction)selectAnswer:(UIButton *)sender {
   // NSLog(@"%@ %@", self.currentQuestion.rightAnswer, sender.titleLabel);
    if ([sender.titleLabel.text isEqual:self.currentQuestion.rightAnswer]) {
        NSInteger nextQuestionNumber = ++self.game.currentQuestionNumber;
        [self loadQuestion:nextQuestionNumber];
    }

}

- (void)loadQuestion:(NSInteger)nextQuestionNumber {
    self.currentQuestion = self.game.questions[nextQuestionNumber];
    self.questionLabel.text = self.currentQuestion.questionText;
   /* [self.answerOne setTitle:self.currentQuestion.answers[0] forState:UIControlStateNormal];
    [self.answerTwo setTitle:self.currentQuestion.answers[1] forState:UIControlStateNormal];
    [self.answerThree setTitle:self.currentQuestion.answers[2] forState:UIControlStateNormal];
    [self.answerFour setTitle:self.currentQuestion.answers[3] forState:UIControlStateNormal];*/
    NSArray *answers = self.currentQuestion.answers;
    for(NSInteger i = 0; i <  answers.count; i++) {
        UIButton *button =  self.answerButtons[i];
        button.hidden = NO;
       [button setTitle:answers[i] forState:UIControlStateNormal];
    }
}

- (IBAction)removeTwoAnswers:(UIButton *)sender {
    UIButton *button =  self.answerButtons[0];
    button.hidden  = YES;
    
}

@end
