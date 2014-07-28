//
//  TextDetailChart.h
//  MAF
//
//  Created by mhahn on 7/27/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNChart.h"

@interface TextDetailChart : NSObject

+ (PNTextChart *)buildChart:(NSArray *)chartItems belowFrame:(CGRect)frame;

@end
