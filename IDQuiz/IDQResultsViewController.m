//
//  IDQResultsViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQResultsViewController.h"
#import "IDQLeaderBoardViewController.h"
#import "AppDelegate.h"
#import "IDQGame.h"
#import "IDQPlayerManager.h"

@interface IDQResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet IDQButton *saveButton;

@end

@implementation IDQResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    IDQGame *game = [IDQGame sharedGame];
    self.timeLabel.text = game.gameState.totalTime;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)game.gameState.totalScore];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (IBAction)saveResult:(IDQButton *)sender {
    if ([self.usernameTextField hasText]) {
        [[IDQGame sharedGame] endGameForUser:self.usernameTextField.text];
        //[self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        IDQLeaderBoardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"leaderBoardVC"];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                                 message:@"Please fill username"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

- (IBAction)cancel:(IDQButton *)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  //  [self.usernameTextField resignFirstResponder];
    return NO;
}*/


@end
