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

@end
