//
//  Comment.h
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>

#import "Post.h"
#import "User.h"

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) NSString *content;

@end
