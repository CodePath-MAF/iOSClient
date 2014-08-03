//
//  Comment.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Comment.h"

@implementation Comment

+ (NSString *)parseClassName {
    return @"Comment";
}

@dynamic user;
@dynamic post;
@dynamic content;

@end
