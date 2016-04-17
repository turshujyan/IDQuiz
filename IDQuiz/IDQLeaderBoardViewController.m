//
//  IDQLeaderBoardViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQLeaderBoardViewController.h"
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
