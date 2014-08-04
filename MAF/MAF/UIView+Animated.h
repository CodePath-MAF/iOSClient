//
//  UIView+Animated.h
//  AnimationPrototype
//
//  Created by Eddie Freeman on 7/31/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP/POP.h>

@interface UIView (Animated)

//- (void)addSubviewWithPopInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
//- (void)removeWithPopOutAnimation:(float)secs option:(UIViewAnimationOptions)option;


// Move To
- (void)moveToPoint:(CGPoint)point withBeginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *, BOOL))complete;
// Scale Up
- (void)scaleUpTo:(CGFloat)scale withCenter:(CGPoint)center beginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *, BOOL))complete;
- (void)scaleUpTo:(CGFloat)scale beginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *, BOOL))complete;
// Scale Down
- (void)scaleDownTo:(CGFloat)scale withBeginTime:(NSTimeInterval)beginTime onCompletion:(void (^)(POPAnimation *, BOOL))complete;

@end
