//
//  User.m
//  MAF
//
//  Created by mhahn on 7/19/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithName:(NSString *)name AndPhoto:(UIImage *)photo {
    self = [super init];
    if (self) {
        _name = name;
        _photo = photo;
    }
    return self;
}

@dynamic totalCash;

@end
