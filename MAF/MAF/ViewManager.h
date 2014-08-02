//
//  ViewManager.h
//  MAF
//
//  Created by mhahn on 7/30/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Bolts.h"
#import <Foundation/Foundation.h>

@interface ViewManager : NSObject

- (BFTask *)fetchViewData:(NSString *)view;
- (BFTask *)fetchViewData:(NSString *)view parameters:(NSDictionary *)parameters;
- (void)clearCache;

+ (ViewManager *)instance;

@end
