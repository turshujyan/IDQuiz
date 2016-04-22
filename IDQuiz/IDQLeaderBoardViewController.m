//
//  IDQLeaderBoardViewController.m
//  IDQuiz
//
//  Created by Hermine on 4/20/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQLeaderBoardViewController.h"
#import "IDQGameViewController.h"
#import "AppDelegate.h"
#import "IDQDataController.h"
#import "IDQGame.h"
#import "IDQResult.h"
#import "IDQLeaderBoardCell.h"

static NSString *customCell = @"leaderBoardCell";

@interface IDQLeaderBoardViewController ()

@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (nonatomic, strong) NSArray *results;
@end

@implementation IDQLeaderBoardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [UIApplication appDelegate];
    self.results = [appDelegate.dataController fetchResults];
    [self.resultsTableView registerNib:[UINib nibWithNibName:@"IDQLeaderBoardCell" bundle:nil] forCellReuseIdentifier:customCell];
}

- (IBAction)home:(IDQButton *)sender {
    if (self.presentingViewController.presentingViewController) {
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDQResult *result = self.results[indexPath.row];
    IDQLeaderBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
    cell.idLabel.text =[NSString stringWithFormat:@"%ld.", indexPath.row + 1 ];
    cell.usernameLabel.text = result.username;
    cell.scoreLabel.text = [result.totalScore stringValue];
    
    NSInteger minutes = [result.totalTime integerValue] / 60;
    NSInteger seconds = [result.totalTime integerValue] % 60;
    
    NSString *minutesString = [NSString stringWithFormat:@"%ld", (long)minutes];
    NSString *secondsString = [NSString stringWithFormat:@"%ld", (long)seconds];
    
    if (minutes <= 10) {
        minutesString = [NSString stringWithFormat:@"0%ld", (long)minutes];
    }
    if (seconds <=10) {
        secondsString = [NSString stringWithFormat:@"0%ld", (long)seconds];
    }
    cell.timeLabel.text =[ NSString stringWithFormat:@"%@:%@", minutesString, secondsString ];

    return cell;
}


@end
