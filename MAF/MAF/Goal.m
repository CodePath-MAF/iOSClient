//
//  Goal.m
//  MAF
//
//  Created by Guy Morita on 7/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Goal.h"
#import <Parse/Parse.h>

@implementation Goal

+ (void)createGoal:(NSString *)name description:(NSString *)description type:(NSInteger)type status:(NSInteger)status amount:(NSInteger)amount numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate {
    PFObject *goal = [PFObject objectWithClassName:@"Goal"];
    goal[@"name"] = name;
    goal[@"description"] = description;
    goal[@"type"] = [NSString stringWithFormat:@"%d", type];
    goal[@"status"] = [NSString stringWithFormat:@"%d", status];
    goal[@"amount"] = [NSString stringWithFormat:@"%d", amount];
    goal[@"numPayments"] = [NSString stringWithFormat:@"%d", numPayments];
//    goal[@"goalDate"] = // not sure how to send it up as a date object
    [goal saveInBackground];
}



@end
