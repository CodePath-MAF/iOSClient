//
//  Friend.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (id)initWithName:(NSString *)name andPhoto:(UIImage *)photo {
    self = [super init];
    if (self) {
        _name = name;
        _photo = photo;
    }
    return self;
}

@end
