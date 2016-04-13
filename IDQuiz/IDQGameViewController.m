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
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation IDQGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [IDQGame sharedGame];
    [self loadQuestion:0];
}

- (IBAction)selectAnswer:(UIButton *)sender {
    NSNumber *index = self.currentQuestion.rightAnswerIndex;
    if ([sender.titleLabel.text isEqual:self.currentQuestion.answers[[index intValue]]]) {
        NSInteger nextQuestionNumber = ++self.game.gameState.currentQuestionNumber;
        [self loadQuestion:nextQuestionNumber];
    }

}

- (void)loadQuestion:(NSInteger)nextQuestionNumber {
    self.currentQuestion = self.game.questions[nextQuestionNumber];
    self.questionLabel.text = self.currentQuestion.questionText;
    NSArray *answers = self.currentQuestion.answers;
    
    //ARAM shuffle answers array before setting to buttons
    for(NSInteger i = 0; i <  answers.count; i++) {
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

@end
