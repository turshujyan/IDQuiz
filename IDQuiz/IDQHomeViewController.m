//
//  IDQHomeViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQHomeViewController.h"
#import "IDQGameViewController.h"

@interface IDQHomeViewController ()

@end

@implementation IDQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(IDQButton *)sender {
    
    IDQPlayerManager *player = [IDQPlayerManager sharedPlayer];
    [player.audioPlayer play];
    
    IDQGame *game = [IDQGame sharedGame];
    [game startNewGame];

    IDQGameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"gameVC"];
    [self presentViewController:vc animated:YES completion:nil];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
