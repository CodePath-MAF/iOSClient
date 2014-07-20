//
//  User.h
//  MAF
//
//  Created by mhahn on 7/19/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface User : PFUser

@property (nonatomic, assign) float totalCash;

- (id)initWithName:(NSString *)name AndPhoto:(UIImage *)photo;
@property NSString *name;
@property UIImage *photo;

@end
