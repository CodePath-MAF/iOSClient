//
//  Friend.h
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

- (id)initWithName:(NSString *)name andPhoto:(UIImage *)photo;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *photo;

@end
