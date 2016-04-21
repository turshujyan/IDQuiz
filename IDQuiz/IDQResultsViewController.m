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


@interface IDQResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation IDQResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    IDQGame *game = [IDQGame sharedGame];
    self.timeLabel.text = game.gameState.totalTime;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)game.gameState.totalScore];
    
    // Do any additional setup after loading the view.
}
- (IBAction)saveResult:(IDQButton *)sender {
    if ([self.usernameTextField hasText]) {
        [[IDQGame sharedGame] endGameForUser:self.usernameTextField.text];
        IDQLeaderBoardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
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

- (IBAction)calcel:(IDQButton *)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    IDQLeaderBoardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    [appDelegate.window setRootViewController:vc];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
