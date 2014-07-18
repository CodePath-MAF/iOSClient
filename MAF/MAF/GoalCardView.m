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

- (void)setGoal:(Goal *)goal {
    _goal = goal;
    self.milestoneLabel.text = [[NSString alloc] initWithFormat:@"%d OF %d", 0, 10];
    self.goalNameLabel.text = self.goal.name;
    self.paymentDueLabel.text = [[NSString alloc] initWithFormat:@"DUE %@", [MHPrettyDate prettyDateFromDate:self.goal.targetDate withFormat:MHPrettyDateFormatNoTime]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // TODO Add Pinch Gesture Recognizer (for custom loading screen)
        
        // Initialization code
    }
    return self;
}

@end