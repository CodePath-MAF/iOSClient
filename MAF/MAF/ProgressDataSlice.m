//
//  ProgressDataSlice.m
//  MAF
//
//  Created by Eddie Freeman on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "ProgressDataSlice.h"

@interface ProgressDataSlice ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic, readwrite) UIColor *color;
@property (nonatomic, readwrite) CGFloat maxValue;

@end

@implementation ProgressDataSlice

+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor *)color {
    
    ProgressDataSlice *item = [ProgressDataSlice new];
    item.value = value;
    item.color = color;
    return item;
}

@end
