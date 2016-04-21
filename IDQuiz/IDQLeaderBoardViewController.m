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


@interface IDQLeaderBoardViewController ()
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (nonatomic, strong) NSArray *results;
@end

@implementation IDQLeaderBoardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [UIApplication appDelegate];
    self.results = [appDelegate.dataController fetchResults];
    [self.resultsTableView registerNib:[UINib nibWithNibName:@"IDQLeaderBoardCell" bundle:nil] forCellReuseIdentifier:@"leaderBoardCell"];



    for(IDQResult *result in self.results) {
       // NSLog(@"%@ %@ %@", result.username, result.totalScore, result.totalTime);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)home:(IDQButton *)sender {
    IDQGameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    [self presentViewController:vc animated:YES completion:nil];
    
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
    IDQLeaderBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaderBoardCell" forIndexPath:indexPath];
    cell.idLabel.text =[NSString stringWithFormat:@"%ld.", indexPath.row + 1 ];
    cell.usernameLabel.text = result.username;
    cell.scoreLabel.text = [result.totalScore stringValue];
    cell.timeLabel.text =[ NSString stringWithFormat:@"%d:%d", [result.totalTime intValue] / 60, [result.totalTime intValue] % 60];

    return cell;
}


@end
