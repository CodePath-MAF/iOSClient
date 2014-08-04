//
//  UIColor+CustomColors.m
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)customGrayColor
{
    return [self colorWithRed:84 green:84 blue:84];
}

+ (UIColor *)customRedColor
{
    return [self colorWithRed:231 green:76 blue:60];
}

+ (UIColor *)customOrangeColor
{
    return [self colorWithRed:255 green:167 blue:19];
}

+ (UIColor *)customVioletColor
{
    return [self colorWithRed:189 green:16 blue:224];
}

+ (UIColor *)customGreenColor
{
    return [self colorWithRed:46 green:204 blue:113];
}

+ (UIColor *)customBlueColor
{
    return [self colorWithRed:73 green:145 blue:226];
}

+ (UIColor *)customLightGrayGolor
{
    return [self colorWithRed:243 green:243 blue:243];
}

+ (UIColor *)customLightFontColor {
    return [self colorWithRed:141 green:141 blue:141];
}

#pragma mark - Private class methods

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

@end
