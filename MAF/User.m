//
//  User.m
//  
//
//  Created by Guy Morita on 7/3/14.
//
//

#import "User.h"
#import <Parse/Parse.h>

@implementation User

+ (void)signUpUser:(NSString *)name email:(NSString *)email password:(NSString *)password phoneNumber:(NSString *)phoneNumber cla:(NSInteger)cla isStaff:(BOOL)isStaff {
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    
    user[@"name"] = name;
    user[@"phoneNumber"] = phoneNumber;
    user[@"cla"] = [NSString stringWithFormat:@"%d", cla];
    NSString *role = @"";
    if (isStaff) {
        role = @"staff";
    } else {
        role = @"user";
    }
    user[@"role"] = role;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Successfully created user");
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
        }
    }];
}

+ (void)loginUser:(NSString *)email password:(NSString *)password {
    [PFUser logInWithUsernameInBackground:@"myname" password:@"mypass"
    block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"Successfully created user");
        } else {
            NSLog(@"Error:%@", error);
        }
    }];
}





@end

