//
//  Goal.h
//  MAF
//
//  Created by Guy Morita on 7/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goal : NSObject
+ (void)createGoal:(NSString *)name description:(NSString *)description type:(NSInteger)type status:(NSInteger)status amount:(NSInteger)amount numPayments:(NSInteger)numPayments goalDate:(NSDate *)goalDate;
@end
