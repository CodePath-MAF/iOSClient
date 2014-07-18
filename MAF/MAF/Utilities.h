//
//  Utilities.h
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHPrettyDate.h"

#define CENTS_TO_DOLLARS_CONSTANT 100
#define TIME_TIL_DUE_STRING @"DUE IN %@ DAYS (%@)"
#define DUE_TODAY_STRING @"DUE TODAY (%@)"
#define NUM_PAYMENTS_MADE @"%d of %d Milestones Achieved"

@interface Utilities : NSObject

+ (NSDate *)dateWithoutTime:(NSDate *)date;

@end
