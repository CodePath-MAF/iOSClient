//
//  NSDictionary+Hash.m
//  MAF
//
//  Created by mhahn on 7/30/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "NSDictionary+Hash.h"

@implementation NSDictionary (Hash)

- (NSUInteger) hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    for (NSObject *key in [[self allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        result = prime * result + [key hash];
        result = prime * result + [self[key] hash];
    }
    return result;
}

@end
