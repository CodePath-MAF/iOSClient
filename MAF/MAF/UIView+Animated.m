//
//  UIView+Animated.m
//  AnimationPrototype
//
//  Created by Eddie Freeman on 7/31/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "UIView+Animated.h"

#define SECOND_MULTIPLIER 1000

typedef struct {
    CGFloat progress;
    CGFloat toValue;
    CGFloat currentValue;
} AnimationInfo;

@implementation UIView (Animated)

- (void) addSubviewWithPopInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
                     }
                     completion:nil];
}

- (void) removeWithPopOutAnimation:(float)secs option:(UIViewAnimationOptions)option
{
	[UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) { 
                         [self removeFromSuperview]; 
                     }];
}

- (void)moveToPoint:(CGPoint)point withBeginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *animation, BOOL animated))complete {
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:point];
    positionAnimation.beginTime = beginTime;
    [self.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
}

- (void)scaleUpTo:(CGFloat)scale withCenter:(CGPoint)center beginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *animation, BOOL animated))complete
{
    [self moveToPoint:center withBeginTime:beginTime onCompletion:nil];
    [self scaleUpTo:scale beginTime:beginTime onCompletion:complete];
}

- (void)scaleUpTo:(CGFloat)scale beginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *animation, BOOL animated))complete
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(scale, scale)];
    scaleAnimation.springBounciness = 10.0f;
    scaleAnimation.beginTime = beginTime;
    [scaleAnimation setCompletionBlock:complete];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)scaleDownTo:(CGFloat)scale withBeginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *animation, BOOL animated))complete
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(scale, scale)];
    scaleAnimation.springBounciness = 10.0f;
    scaleAnimation.beginTime = beginTime;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)pauseAllAnimations:(BOOL)pause forLayer:(CALayer *)layer
{
    for (NSString *key in layer.pop_animationKeys) {
        POPAnimation *animation = [layer pop_animationForKey:key];
        [animation setPaused:pause];
    }
}

- (AnimationInfo)animationInfoForLayer:(CALayer *)layer
{
    POPSpringAnimation *animation = [layer pop_animationForKey:@"scaleAnimation"];
    CGPoint toValue = [animation.toValue CGPointValue];
    CGPoint currentValue = [[animation valueForKey:@"currentValue"] CGPointValue];
    
    CGFloat min = MIN(toValue.x, currentValue.x);
    CGFloat max = MAX(toValue.x, currentValue.x);
    
    AnimationInfo info;
    info.toValue = toValue.x;
    info.currentValue = currentValue.x;
    info.progress = min / max;
    return info;
}

@end
