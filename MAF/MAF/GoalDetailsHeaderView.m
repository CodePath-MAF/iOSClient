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

// Goal Details Circle
#import <POP/POP.h>
#import "UIView+Animated.h"
#import "UIView+Circle.h"
#import "GoalDetailsCircleView.h"
#import "UIColor+CustomColors.h"

#define CIRCLE_OFFSET 20.0
#define BIG_CIRCLE_DIAMETER 130.0
#define SMALL_CIRCLE_DIAMETER 40.0f
#define BAR_HEIGHT 20.0f
#define DEFAULT_USER_COUNT 4.0f

@interface GoalDetailsHeaderView()

@property (nonatomic) BOOL _goalProgressChartAnimated;

@property (weak, nonatomic) IBOutlet UIView *_goalInformationView;
@property (weak, nonatomic) IBOutlet GoalDetailsCircleView *_goalProgressView;
@property (strong, nonatomic) PNCircleChart *_goalProgressChart;
@property (nonatomic, strong) UIView *_progressBar;

@property (nonatomic, strong) UIBezierPath *friendsPath;
@property (nonatomic) BOOL toggle;
@property (nonatomic, strong) NSMutableArray *friendViews;
@property (nonatomic, strong) NSArray *circleDestinations;

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
        self._progressBar.backgroundColor = [UIColor customGreenColor];
        self._progressBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self._progressBar];
        [self _addConstraintsToProgressBar];
    }
    
    [UIView beginAnimations:@"" context:nil];
    
    if (layoutAttributes.progressiveness <= 0.16) {
        [self _addAlphaToLendingCircleDetails:0];
    } else {
        [self _addAlphaToLendingCircleDetails:1];
    }
    
    if (layoutAttributes.progressiveness <= 0.15) {
        self._progressBar.alpha = 1;
    } else {
        self._progressBar.alpha = 0;
    }
    
    if (!self._goalProgressChartAnimated) {
//        [self _animateGoalProgressChart];
        [self _animateSocialCircles];
        self._goalProgressChartAnimated = YES;
    }
    
    [UIView commitAnimations];
}

- (void)_addAlphaToLendingCircleDetails:(CGFloat)alpha {
    self._goalProgressView.alpha = alpha;
    [self.friendViews enumerateObjectsUsingBlock:^(UIView *friendView, NSUInteger idx, BOOL *stop) {
        friendView.alpha = alpha;
    }];
}

- (void)_addConstraintsToProgressBar {
    NSDictionary *viewsDictionary = @{@"subview": self._progressBar};
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview(50)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview(256)]"
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

- (void)_addConstraintsToFriendView:(UIView *)friendView {
    NSDictionary *viewsDictionary = @{@"subview": friendView};
    
    NSString *constaint_H1 = [[NSString alloc] initWithFormat:@"V:[subview(%f)]", friendView.frame.size.width];
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:constaint_H1
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSString *constraint_V1 = [[NSString alloc] initWithFormat:@"H:[subview(%f)]", friendView.frame.size.height];
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:constraint_V1
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSString *horizontalConstraint = [[NSString alloc] initWithFormat:@"H:|-%f-[subview]", friendView.frame.origin.x];
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraint
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    float vertical = self._goalInformationView.frame.size.height - friendView.frame.origin.y - friendView.frame.size.height;
    if (vertical < 0) {
        vertical = 0;
    }
    NSString *verticalConstraint = [[NSString alloc] initWithFormat:@"V:[subview]-%f-|", vertical];
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraint
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    [friendView addConstraints:constraint_H];
    [friendView addConstraints:constraint_V];
    [self addConstraints:constraint_POS_H];
    [self addConstraints:constraint_POS_V];
    
}

- (void)_animateSocialCircles {
//    [self addGoalDetailsView];
//    [self._goalProgressView scaleUpTo:1.0f beginTime:0.0f onCompletion:nil];
    [self._goalProgressView setStrokeEnd:0.8 animated:YES];

    self.friendViews = [[NSMutableArray alloc] init];
//    CGFloat radius = BIG_CIRCLE_DIAMETER/2+CIRCLE_OFFSET+SMALL_CIRCLE_DIAMETER/2;
    CGPoint topCenter = CGPointMake(self._goalProgressView.center.x, self._goalProgressView.center.y);

    for (int userNum = 0; userNum < 8; userNum++) {
        NSString *photoName = [[NSString alloc] initWithFormat:@"profile_%d", userNum+1];
        UIImageView *friendView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:photoName]];
        friendView.center = topCenter;
        [friendView setRoundedWithDiameter:SMALL_CIRCLE_DIAMETER];
        friendView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.friendViews addObject:friendView];
        [self._goalInformationView addSubview:friendView];
    }

    // Find Destinations around Center Circle
    self.circleDestinations = [self findPointsForItems:self.friendViews aroundCircleView:self._goalProgressView];

    // Animate around Circle
    [self popInViews:self.friendViews withDestinations:self.circleDestinations];
    
}

#pragma mark - Add Views

//- (void)addGoalDetailsView
//{
//    CGPoint goalCenter = CGPointMake(self._goalInformationView.center.x, BIG_CIRCLE_DIAMETER + SMALL_CIRCLE_DIAMETER + CIRCLE_OFFSET);
//    self._goalProgressView = [[_goalProgressViewView alloc] initWithDiameter:BIG_CIRCLE_DIAMETER atPoint:goalCenter];
//    self._goalProgressView.backgroundColor = [UIColor clearColor];
//    self._goalProgressView.translatesAutoresizingMaskIntoConstraints = NO;
//    self._goalProgressView.strokeColor = [UIColor customGreenColor];
//    
//    // first reduce the view to 1/100th of its original dimension
//    CGAffineTransform trans = CGAffineTransformScale(self._goalProgressView.transform, 0.01, 0.01);
//    self._goalProgressView.transform = trans;  // do it instantly, no animation
//    
//    [self._goalInformationView addSubview:self._goalProgressView];
//    [self _addConstraintsToFriendView:self._goalProgressView];
//}


#pragma mark - Goal Details Circle Animations

- (void)popInViews:(NSArray *)views withDestinations:(NSArray *)destinations {
    NSInteger itemCount = 0;
    for (UIView *friendView in self.friendViews) {
        CGPoint destination = [destinations[itemCount] CGPointValue];
        // first reduce the view to 1/100th of its original dimension
        CGAffineTransform trans = CGAffineTransformScale(friendView.transform, 0.01, 0.01);
        friendView.transform = trans;	// do it instantly, no animation
        // set starting point for friend view (NOT USED)
        //        CGPoint startPoint = (itemCount > 0) ? destination : friendView.center;
        NSLog((self.toggle)? @"YES":@"NO");
        if (!self.toggle) {
            friendView.center = destination;
        }
        
        if (itemCount % 2) { // TODO adjust to the current user/payment user
            friendView.layer.borderWidth = 2;
            friendView.layer.borderColor = [UIColor customGreenColor].CGColor;
        }
        // Not USED RIGHT NOW
        //        // find start/destination slope
        //        CGFloat radius = BIG_CIRCLE_DIAMETER/2+CIRCLE_OFFSET+SMALL_CIRCLE_DIAMETER/2;
        //
        //        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        //        positionAnimation.beginTime = CACurrentMediaTime() + itemCount*.25;
        //        positionAnimation.duration = .5;
        //        positionAnimation.path = [UIBezierPath bezierPathWithArcCenter:self._goalProgressView.center
        //                                                                radius:radius
        //                                                            startAngle:0.2f
        //                                                              endAngle:0.2f
        //                                                             clockwise:YES].CGPath;
        //        positionAnimation.calculationMode = kCAAnimationPaced;
        //        [friendView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        [friendView scaleUpTo:1.0f beginTime:CACurrentMediaTime() + itemCount*.15 onCompletion:^(POPAnimation *animation, BOOL animated) {
            NSLog(@"superview: %@", friendView.superview);
            NSLog(@"friendView: %@", friendView);
            [self _addConstraintsToFriendView:friendView];
        }];
        itemCount++;
    }
}

- (void)animateViews:(NSArray *)views toDestinations:(NSArray *)destinations {
    for (NSInteger countA = 0; countA < [views count]; countA++) {
        CGPoint destination = [destinations[countA] CGPointValue];
        UIImageView *friendView = [views objectAtIndex:countA];
        
        // calculate animation path / arc
        if (countA % 2) {
            friendView.layer.borderWidth = 2;
            friendView.layer.borderColor = [UIColor customGreenColor].CGColor;
        }
        [friendView scaleUpTo:0.8f withCenter:destination beginTime:CACurrentMediaTime() + countA*.15 onCompletion:^(POPAnimation *animation, BOOL animated) {
            [self _addConstraintsToFriendView:friendView];
        }];
    }
}

- (NSArray *)findPointsForItems:(NSArray *)items aroundCircleView:(UIView *)view {
    NSMutableArray *destinations = [[NSMutableArray alloc] init];
    
    CGFloat radius = BIG_CIRCLE_DIAMETER/2 + SMALL_CIRCLE_DIAMETER/2 + CIRCLE_OFFSET;
    CGPoint center = view.center;
    center.y += 73;
    NSInteger itemCount = [items count];
    for (int itemNum = 0; itemNum < itemCount; itemNum++) {
        CGFloat itemRatio = (float)itemNum/(float)itemCount;
        CGFloat x = center.x + radius * cosf(itemRatio * 2*M_PI - M_PI_2); // minus pi/2 to start at top of circle
        CGFloat y = center.y + radius * sinf(itemRatio * 2*M_PI - M_PI_2); // minus pi/2 to start at top of circle
        NSValue *destination = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [destinations addObject:destination];
    }
    
    return destinations;
}

@end
