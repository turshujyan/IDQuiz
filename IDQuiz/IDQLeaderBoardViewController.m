//
//  IDQLeaderBoardViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQLeaderBoardViewController.h"
#import "IDQGameViewController.h"
#import "IDQGame.h"

@interface IDQLeaderBoardViewController ()

@end

@implementation IDQLeaderBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    IDQGame *game = [IDQGame sharedGame];
    [game getLeaderBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)home:(IDQButton *)sender {
    IDQGameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    [self presentViewController:vc animated:YES completion:nil];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
