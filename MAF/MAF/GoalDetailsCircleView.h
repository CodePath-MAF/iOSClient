//
//  GoalDetailsCircleView.h
//  MAF
//
//  Created by Eddie Freeman on 7/31/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GoalDetailsCircleView : UIView

@property (nonatomic, assign) CGFloat diameter;
@property(nonatomic) UIColor *strokeColor;

- (id)initWithDiameter:(CGFloat)diameter atPoint:(CGPoint)origin;
- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;

@end
