//
//  GoalCardView.m
//  MAF
//
//  Created by Eddie Freeman on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "GoalCardView.h"
#import "Utilities.h"

@interface GoalCardView ()

@property (weak, nonatomic) IBOutlet UILabel *milestoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentDueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dueImageView;

@end

@implementation GoalCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // TODO Add Pinch Gesture Recognizer (for custom loading screen)
        
        // Initialization code
    }
    return self;
}

- (void)setGoal:(Goal *)goal {
    _goal = goal;
    
     NSInteger newMilestoneCount = self.goal.currentProgress/self.goal.paymentAmount;
    self.milestoneLabel.text = [[NSString alloc] initWithFormat:@"%d OF %d", newMilestoneCount, self.goal.numPayments];
    self.goalNameLabel.text = self.goal.name;
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.goal.paymentAmount];
   
    self.paymentDueLabel.text = [Utilities prettyMessageFromTargetDate:self.goal.targetDate withStartDate:[self.goal createdAt] withInterval:self.goal.paymentInterval];
}

- (void)updateColors {
    if([Utilities isWithinWeekOfTargetDate:self.goal.targetDate withStartDate:[self.goal createdAt] withInterval:self.goal.paymentInterval]) {
        [self.dueImageView setImage:[UIImage imageNamed:@"time_red"]];
        [self.paymentDueLabel setTextColor:[UIColor redColor]];
    }
}

@end
