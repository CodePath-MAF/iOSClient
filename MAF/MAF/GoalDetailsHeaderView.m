//
//  GoalDetailsHeaderView.m
//  MAF
//
//  Created by mhahn on 8/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CSStickyHeaderFlowLayoutAttributes.h"
#import "PNChart.h"

#import "GoalDetailsHeaderView.h"

@interface GoalDetailsHeaderView()

@property (weak, nonatomic) IBOutlet UIView *_goalInformationView;
@property (weak, nonatomic) IBOutlet UIView *_goalProgressView;
@property (nonatomic) BOOL _goalProgressChartAnimated;
@property (strong, nonatomic) PNCircleChart *_goalProgressChart;
@property (nonatomic, strong) UIView *_progressBar;

@end

@implementation GoalDetailsHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self._goalProgressChartAnimated = NO;
    }
    return self;
}

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
    
    if (!self._progressBar) {
        self._progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, self._goalInformationView.frame.size.height, 100, 50)];
        self._progressBar.backgroundColor = [UIColor greenColor];
        self._progressBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self._progressBar];
        [self _addConstraintsToProgressBar];
    }
    
    [UIView beginAnimations:@"" context:nil];
    
    if (layoutAttributes.progressiveness <= 0.4) {
        self._goalProgressChart.alpha = 0;
    } else {
        self._goalProgressChart.alpha = 1;
    }
    
    if (layoutAttributes.progressiveness <= 0.15) {
        self._progressBar.alpha = 1;
    } else {
        self._progressBar.alpha = 0;
    }
    
    if (!self._goalProgressChartAnimated) {
        [self _animateGoalProgressChart];
        self._goalProgressChartAnimated = YES;
    }
    
    [UIView commitAnimations];
}

- (void)_addConstraintsToProgressBar {
    NSDictionary *viewsDictionary = @{@"subview": self._progressBar};
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview(50)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview(100)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    [self._progressBar addConstraints:constraint_H];
    [self._progressBar addConstraints:constraint_V];
    [self addConstraints:constraint_POS_H];
    [self addConstraints:constraint_POS_V];
}

- (void)_animateGoalProgressChart {
    NSInteger width = 100;
    self._goalProgressChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 30, width, width) andTotal:@(100) andCurrent:[NSNumber numberWithFloat:0.30*100] andClockwise:YES andShadow:YES];
    self._goalProgressChart.backgroundColor = [UIColor clearColor];
    self._goalProgressChart.lineWidth = [NSNumber numberWithInt:3];
    self._goalProgressChart.countingLabel.textColor = [UIColor clearColor];
    [self._goalProgressChart setStrokeColor:[UIColor colorWithRed:86.0f/255.0f green:150.0f/255.0f blue:231.0f/255.0f alpha:1.0f]];
    [self._goalProgressChart strokeChart];
    [self._goalProgressView addSubview:self._goalProgressChart];
}

@end
