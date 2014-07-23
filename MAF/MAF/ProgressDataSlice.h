//
//  ProgressDataSlice.h
//  MAF
//
//  Created by Eddie Freeman on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressDataSlice : NSObject

+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor*)color;

@property (nonatomic, readonly) CGFloat value;
@property (nonatomic, readonly) UIColor *color;

@end
