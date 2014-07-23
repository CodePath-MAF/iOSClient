//
//  Utilities.m
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Utilities.h"

@interface Utilities ()

@end


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

+ (NSDateComponents *)getDateComponentsForDate:(NSDate *)date {
    return [[NSCalendar currentCalendar] components:(NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
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

+ (NSString *)prettyMessageFromTargetDate:(NSDate *)targetDate withStartDate:(NSDate *)startDate withInterval:(NSInteger)interval {
    NSDate *strippedDateToday = [Utilities dateWithoutTime:[NSDate date]];
    NSInteger daysTil = [Utilities daysBetweenDate:startDate andDate:targetDate]%interval;
    
    NSLog(@"Days Til: %d", daysTil);
    
    NSDate *newDate = [NSDate dateWithTimeInterval:daysTil*24*60*60 sinceDate:strippedDateToday];
    NSString *nextDue = @"";
    if ([MHPrettyDate isToday:newDate]) {
        nextDue = [[NSString alloc] initWithFormat:@"DUE TODAY!"];
    }
    else if ([MHPrettyDate isTomorrow:newDate]) {
        nextDue = [[NSString alloc] initWithFormat:@"DUE TOMORROW"];
    }
    else if ([MHPrettyDate isWithinWeek:newDate]) {
        nextDue = [[NSString alloc] initWithFormat:@"DUE IN %d DAYS", daysTil];
    }
    else {
        NSDateComponents *compontents = [Utilities getDateComponentsForDate:newDate];
        nextDue = [[NSString alloc] initWithFormat:@"DUE IN %@ (%@)", [[Utilities getMonthSymbolForMonthNumber:compontents.month] uppercaseString], [MHPrettyDate prettyDateFromDate:newDate withFormat:MHPrettyDateFormatNoTime]];
    }
    
    return nextDue;
}

+ (NSString *)getMonthSymbolForMonthNumber:(NSInteger)monthNumber {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *symbols = [formatter monthSymbols];
    return symbols[monthNumber - 1];
}

+ (BOOL)isWithinWeekOfTargetDate:(NSDate *)targetDate withStartDate:(NSDate *)startDate  withInterval:(NSInteger)interval {
    NSDate *strippedDate = [self dateWithoutTime:startDate];
    NSInteger daysTil = [self daysBetweenDate:strippedDate andDate:targetDate]%interval;
    NSDate *newDate = [NSDate dateWithTimeInterval:daysTil*24*60*60 sinceDate:strippedDate];
    return [MHPrettyDate isWithinWeek:newDate];
}

@end
