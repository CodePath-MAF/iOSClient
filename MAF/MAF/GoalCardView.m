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
#import <UICountingLabel.h>


@interface GoalCardView ()

@property (weak, nonatomic) IBOutlet UILabel *milestoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentDueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *percentCompleteLabel;


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
    
    
#warning TODO add Milestone Update
    NSInteger newMilestoneCount = 0;
    self.milestoneLabel.text = [[NSString alloc] initWithFormat:@"%d OF %d", newMilestoneCount, self.goal.numPayments];
    self.goalNameLabel.text = self.goal.name;
    self.paymentAmountLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.goal.paymentAmount];
   
    self.paymentDueLabel.text = [Utilities prettyMessageFromTargetDate:self.goal.goalDate withStartDate:[self.goal createdAt] withInterval:self.goal.paymentInterval];
    
    float percentComplete = self.goal.currentTotal / self.goal.amount;
    self.percentCompleteLabel.format = @"%d%%";
    self.percentCompleteLabel.method = UILabelCountingMethodEaseInOut;
    [self.percentCompleteLabel countFrom:0 to:percentComplete*100 withDuration:1.0];
    
    [self addCircle:percentComplete];
}

- (void)updateColors {
    if([Utilities isWithinWeekOfTargetDate:self.goal.goalDate withStartDate:[self.goal createdAt] withInterval:self.goal.paymentInterval]) {
        [self.dueImageView setImage:[UIImage imageNamed:@"time_red"]];
        [self.paymentDueLabel setTextColor:[UIColor redColor]];
    }
}

- (void)addCircle:(float)percentageComplete {
    
    // Set up the shape of the circle
    int radius = 40;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.frame)-radius,
                                  CGRectGetMidY(self.frame)-radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 5;
    circle.strokeEnd = percentageComplete;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:percentageComplete];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

@end
