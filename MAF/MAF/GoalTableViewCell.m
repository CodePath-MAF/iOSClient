//
//  GoalTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "GoalTableViewCell.h"

@interface GoalTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *goalNameLabel;

@end

@implementation GoalTableViewCell


- (void)setGoal:(Goal *)goal {
    _goal = goal;
    self.goalNameLabel.text = goal.name;
    // TODO configure the rest of the displays for the goals
}

@end
