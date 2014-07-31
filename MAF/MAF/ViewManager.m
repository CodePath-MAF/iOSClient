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

- (BFTask *)fetchViewData:(NSString *)view parameters:(NSDictionary *)parameters {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    NSString *cacheKey = [NSString stringWithFormat:@"%@:%d", view, [parameters hash]];
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

+ (ViewManager *)instance {
    static ViewManager *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[ViewManager alloc] init];
    });
    return instance;
}

@end
