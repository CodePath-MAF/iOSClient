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
@property (weak, nonatomic) IBOutlet UIImageView *circleTypeImage;


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
    self.layer.cornerRadius = 5;
    self.goalNameLabel.text = self.goal.name;
    [self setCircleImage:goal];
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"($%0.2f)", self.goal.paymentAmount];
    float percentComplete = goal.currentTotal / self.goal.amount;
    self.percentCompleteLabel.format = @"%d%%";
    self.percentCompleteLabel.method = UILabelCountingMethodEaseIn;
    self.percentCompleteLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:32.0];
    [self.percentCompleteLabel countFrom:0.0 to:percentComplete*100 withDuration:1.0];
    [self addPNCircle:percentComplete goal:goal];
    [self sendSubviewToBack:self.animatedChart];
}

- (void)setCircleImage:(Goal *)goal {
    if (goal.type == GoalTypeGoal) {
        self.circleTypeImage.image = [UIImage imageNamed:@"img_lending_icon_blue"];
    } else if (goal.type == GoalTypeLendingCircle) {
        self.circleTypeImage.image = [UIImage imageNamed:@"img_goal_icon_orange"];
    }
}

- (void)setPrettyDueDate:(NSDictionary *)prettyDueDate {
    self.paymentDueLabel.text = prettyDueDate[@"prettyDate"];
    if ([prettyDueDate[@"warning"] boolValue]) {
        self.dueImageView.image = [UIImage imageNamed:@"time_red"];
    } else {
        self.dueImageView.image = [UIImage imageNamed:@"time_gray"];
    }
}

- (void)addPNCircle:(float)percentageComplete goal:(Goal*)goal{
    int width = 115;
    self.animatedChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(9, 36, width, width) andTotal:@100 andCurrent:[NSNumber numberWithFloat:percentageComplete*100] andClockwise:YES andShadow:YES];
    self.animatedChart.backgroundColor = [UIColor clearColor];
    self.animatedChart.lineWidth = [NSNumber numberWithInt:3];
    self.animatedChart.countingLabel.textColor = [UIColor clearColor];
    if (goal.type == GoalTypeGoal) {
        [self.animatedChart setStrokeColor:[UIColor colorWithRed:86.0f/255.0f green:150.0f/255.0f blue:231.0f/255.0f alpha:1.0f]];
    } else if (goal.type == GoalTypeLendingCircle) {
        [self.animatedChart setStrokeColor:[UIColor colorWithRed:255.0f/255.0f green:167.0f/255.0f blue:19.0f/255.0f alpha:1.0f]];
    }

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
