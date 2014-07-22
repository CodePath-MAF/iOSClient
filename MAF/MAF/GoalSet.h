//
//  GoalSet.h
//  MAF
//
//  Created by Eddie Freeman on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoalSet : NSObject

@property (nonatomic, strong) NSMutableArray *goals;

- (id)initWithGoals:(NSArray *)goals;
- (NSDictionary *)goalsTotalByDate;
- (NSDictionary *)goalsByDate;
- (float)goalsTotalForToday;
- (float)goalsTotalForCurrentWeek;

@end
