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

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
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

@end
