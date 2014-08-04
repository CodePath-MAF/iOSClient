//
//  Post.h
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Goal.h"

NS_ENUM(NSInteger, PostType) {
    PostTypeMessage = 1,
    PostTypeQuestion = 2,
    PostTypeEvent = 3,
    PostTypePayment = 4,
};

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Goal *goal;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) enum PostType type;
@property (nonatomic, strong) PFFile *photo;
@property (nonatomic, strong) User *toUser;
@property (nonatomic, strong) NSMutableArray *comments;

- (NSMutableArray *)getComments;

@end
