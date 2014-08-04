//
//  UIView+Circle.m
//  AnimationPrototype
//
//  Created by Eddie Freeman on 8/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "UIView+Circle.h"

@implementation UIView (Circle)

- (void)setRoundedWithDiameter:(float)newSize;
{
    CGPoint saveCenter = self.center;
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSize, newSize);
    self.frame = newFrame;
    self.layer.cornerRadius = newSize / 2.0; // half the diamater
    self.center = saveCenter;
}

@end
