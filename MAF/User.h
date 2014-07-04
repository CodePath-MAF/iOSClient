//
//  User.h
//  
//
//  Created by Guy Morita on 7/3/14.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject
+ (void)signUpUser:(NSString *)name email:(NSString *)email password:(NSString *)password phoneNumber:(NSString *)phoneNumber cla:(NSInteger)cla isStaff:(BOOL)isStaff;
@end
