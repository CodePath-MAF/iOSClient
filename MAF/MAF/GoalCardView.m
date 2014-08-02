//
//  GoalCardView.m
//  MAF
//
//  Created by Eddie Freeman on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "GoalCardView.h"
#import "Utilities.h"
#import "OpenSansLightLabel.h"
#import "TransactionManager.h"
#import <PNCircleChart.h>
#import <UICountingLabel.h>


@interface GoalCardView ()

@property (weak, nonatomic) IBOutlet UILabel *milestoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentDueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *percentCompleteLabel;
@property (strong, nonatomic) PNCircleChart *animatedChart;


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
    
    
//#warning TODO add Milestone Update
//    NSInteger newMilestoneCount = 0;
//    self.milestoneLabel.text = [[NSString alloc] initWithFormat:@"%d OF %d", newMilestoneCount, self.goal.numPayments];
    self.goalNameLabel.text = self.goal.name;
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"($%0.2f)", self.goal.paymentAmount];
   
    self.paymentDueLabel.text = [Utilities prettyMessageFromTargetDate:self.goal.goalDate withStartDate:[self.goal createdAt] withInterval:self.goal.paymentInterval];
    
    NSArray *payments = [[[TransactionManager instance] transactionsSet] transactionsForGoalId:[self.goal objectId]];
    
    float amountPaid = 0;
    for (Transaction *t in payments) {
        amountPaid += t.amount;
    }
    amountPaid = roundf(amountPaid);
    

    
    float percentComplete = amountPaid / self.goal.amount;
    self.percentCompleteLabel.format = @"%d%%";
    self.percentCompleteLabel.method = UILabelCountingMethodEaseIn;
    [self.percentCompleteLabel countFrom:0.0 to:percentComplete*100 withDuration:1.0];
    [self addPNCircle:percentComplete];
    
}

- (void)updateColors {
    if([Utilities isWithinWeekOfTargetDate:self.goal.goalDate withStartDate:[self.goal createdAt] withInterval:self.goal.paymentInterval]) {
        [self.dueImageView setImage:[UIImage imageNamed:@"time_red"]];
        [self.paymentDueLabel setTextColor:[UIColor redColor]];
    }
}

- (void)addPNCircle:(float)percentageComplete {
    int width = 120;
    self.animatedChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(10, 40, width, width) andTotal:@100 andCurrent:[NSNumber numberWithFloat:percentageComplete*100] andClockwise:YES andShadow:YES];
    self.animatedChart.backgroundColor = [UIColor clearColor];
    self.animatedChart.lineWidth = [NSNumber numberWithInt:2];
    self.animatedChart.countingLabel.textColor = [UIColor clearColor];
    [self.animatedChart setStrokeColor:PNGreen];
    [self.animatedChart strokeChart];
    [self addSubview:self.animatedChart];
}

@end
