//
//  Utilities.m
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities

+ (NSDate *)dateWithoutTime:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDate *strippedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    return strippedDate;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
  NSDate *fromDate;
  NSDate *toDate;
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
               interval:nil forDate:fromDateTime];
  [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
               interval:nil forDate:toDateTime];
  
  NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                             fromDate:fromDate toDate:toDate options:0];
  
  return [difference day];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (hexString.length) {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    } else {
        return [UIColor blackColor];
    }
}

+ (NSArray *)getPreviousDates:(int)numPreviousDates fromDate:(NSDate *)fromDate {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:fromDate];
    NSInteger currentDay = [components day];
    
    NSMutableArray *previousDates = [[NSMutableArray alloc] initWithObjects:fromDate, nil];
    for (int i=1; i < numPreviousDates; i++) {
        [components setDay:currentDay - i];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        [previousDates addObject:date];
    }
    
    return [[NSArray alloc] initWithArray:previousDates];
}

+ (UIButton *)setupRoundedButton:(UIButton *)button withCornerRadius:(CGFloat)cornerRadius {
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = button.tintColor.CGColor;
    button.layer.borderWidth = 2.0f;
    
    return button;
}

+ (NSInteger)numberOfMilestonesforGoal:(Goal *)goal {
    NSInteger daysToGoal = [self daysBetweenDate:[NSDate new] andDate:goal.targetDate];
    return floor(daysToGoal/goal.paymentInterval);
}

@end
