//
//  Utilities.h
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+CustomColors.h"
#import "UIView+Animated.h"
#import "UIView+Circle.h"
#import "MHPrettyDate.h"
#import "Goal.h"

//#define CENTS_TO_DOLLARS_CONSTANT 100
#define TIME_TIL_DUE_STRING @"DUE IN %d DAYS (%@)"
#define DUE_TODAY_STRING @"DUE TODAY (%@)"
#define NUM_PAYMENTS_MADE @"%d of %d Milestones Achieved"
#define BUTTON_CORNER_RADIUS 18.0f

@interface Utilities : NSObject

+ (NSDateComponents *)getDateComponentsForDate:(NSDate *)date;
+ (NSDate *)dateWithoutTime:(NSDate *)date;
+ (NSArray *)getPreviousDates:(int)numPreviousDates fromDate:(NSDate *)fromDate;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIButton *)setupRoundedButton:(UIButton *)button withCornerRadius:(CGFloat)cornerRadius;

@end
