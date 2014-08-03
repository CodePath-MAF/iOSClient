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

    self.goalNameLabel.text = self.goal.name;
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"($%0.2f)", self.goal.paymentAmount];
    float percentComplete = goal.currentTotal / self.goal.amount;
    self.percentCompleteLabel.format = @"%d%%";
    self.percentCompleteLabel.method = UILabelCountingMethodEaseIn;
    [self.percentCompleteLabel countFrom:0.0 to:percentComplete*100 withDuration:1.0];
    [self addPNCircle:percentComplete];
}

- (void)setPrettyDueDate:(NSDictionary *)prettyDueDate {
    self.paymentDueLabel.text = prettyDueDate[@"prettyDate"];
    if ([prettyDueDate[@"warning"] boolValue]) {
        self.dueImageView.image = [UIImage imageNamed:@"time_red"];
    } else {
        self.dueImageView.image = [UIImage imageNamed:@"time_gray"];
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

- (void)prepareForReuse {
    self.animatedChart = nil;
    self.goal = nil;
    self.paymentAmountLabel.text = nil;
    self.paymentDueLabel.text = nil;
    self.percentCompleteLabel.text = @"0%";
}

@end
