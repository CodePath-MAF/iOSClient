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

@interface Utilities : NSObject

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end
