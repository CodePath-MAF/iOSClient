//
//  Post.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (NSString *)parseClassName {
    return @"Post";
}

@dynamic user;
@dynamic goal;
@dynamic content;
@dynamic type;
@dynamic photo;
@dynamic toUser;
@dynamic comments;

- (NSMutableArray *)getComments {
    if (self.comments) {
        return self.comments;
    } else {
        return [[NSMutableArray alloc] init];
    }
}

@end
