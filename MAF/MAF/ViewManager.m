//
//  ViewManager.m
//  MAF
//
//  Created by mhahn on 7/30/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "ViewManager.h"
#import "NSDictionary+Hash.h"
#import "User.h"
#import "Utilities.h"

@interface ViewManager()

@property (nonatomic, strong) NSMutableDictionary *_viewDataCache;

@end

@implementation ViewManager

- (id)init {
    self = [super init];
    if (self) {
        self._viewDataCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BFTask *)fetchViewData:(NSString *)view {
    if ([view isEqualToString:@"stackedBarChartDetailView"]) {
        return [self stackedBarChartDetailView];
    } else if ([view isEqualToString:@"dashboardView"]) {
        return [self dashboardView];
    } else {
        BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
        NSError *error = [[NSError alloc] initWithDomain:@"viewManager" code:1 userInfo:@{@"error": [[NSString alloc] initWithFormat:@"ViewManager does not know how to handle view: %@", view]}];
        [task setError:error];
        return task.task;
    }
}

- (BFTask *)dashboardView {
    return [self fetchViewData:@"dashboardView" parameters:[[NSDictionary alloc] init]];
}

- (BFTask *)stackedBarChartDetailView {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate new]];
    return [self fetchViewData:@"stackedBarChartDetailView"
                    parameters:@{
                                 @"userId": [[User currentUser] objectId],
                                 @"year": @(components.year),
                                 @"month": @(components.month),
                                 @"day": @(components.day),
                                 @"today": [Utilities dateWithoutTime:[NSDate new]]
                                 }];

}

- (BFTask *)fetchViewData:(NSString *)view parameters:(NSDictionary *)parameters {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    NSString *cacheKey = [NSString stringWithFormat:@"%@:%lu", view, (unsigned long)[parameters hash]];
    NSDictionary *cachedResponse = self._viewDataCache[cacheKey];
    if (cachedResponse) {
        [task setResult:cachedResponse];
    } else {
        [PFCloud callFunctionInBackground:view withParameters:parameters block:^(NSDictionary *response, NSError *error) {
            if (error) {
                [task setError:error];
            } else {
                self._viewDataCache[cacheKey] = response;
                [task setResult:response];
            }
        }];
    }
    return task.task;
}

- (void)clearCache {
    self._viewDataCache = [[NSMutableDictionary alloc] init];
}

+ (ViewManager *)instance {
    static ViewManager *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[ViewManager alloc] init];
    });
    return instance;
}

@end
