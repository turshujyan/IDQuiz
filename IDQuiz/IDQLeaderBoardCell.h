//
//  IDQLeaderBoardCell.h
//  IDQuiz
//
//  Created by Hermine on 4/20/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDQLeaderBoardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
