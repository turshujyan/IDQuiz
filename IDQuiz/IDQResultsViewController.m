//
//  IDQResultsViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQResultsViewController.h"
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
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
