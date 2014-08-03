//
//  UILabel+WhiteUIDatePickerLabels.m
//  MAF
//
//  Created by Guy Morita on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "UILabel+WhiteUIDatePickerLabels.h"
#import <objc/runtime.h>

@implementation UILabel (WhiteUIDatePickerLabels)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setTextColor:)
                      withNewSelector:@selector(swizzledSetTextColor:)];
        [self swizzleInstanceSelector:@selector(setFont:)
                      withNewSelector:@selector(swizzledSetFont:)];
        [self swizzleInstanceSelector:@selector(willMoveToSuperview::)
                      withNewSelector:@selector(swizzledWillMoveToSuperview:)];
    });
}

// Forces the text colour of the label to be white only for UIDatePicker and its components
-(void) swizzledSetTextColor:(UIColor *)textColor {
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]){
        [self swizzledSetTextColor:[UIColor whiteColor]];
    } else {
        //Carry on with the default
        [self swizzledSetTextColor:textColor];
    }
}

-(void) swizzledSetFont:(UIFont *)uiFont {
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]){
        [self swizzledSetFont:[UIFont fontWithName:@"OpenSans-Light" size:24.f]];
    } else {
        //Carry on with the default
        [self swizzledSetFont:uiFont];
    }
}

// Some of the UILabels haven't been added to a superview yet so listen for when they do.
- (void) swizzledWillMoveToSuperview:(UIView *)newSuperview {
    [self swizzledSetTextColor:self.textColor];
    [self swizzledSetFont:self.font];
    [self swizzledWillMoveToSuperview:newSuperview];
}

// -- helpers --
- (BOOL) view:(UIView *) view hasSuperviewOfClass:(Class) class {
    if(view.superview){
        if ([view.superview isKindOfClass:class]){
            return true;
        }
        return [self view:view.superview hasSuperviewOfClass:class];
    }
    return false;
}

+ (void) swizzleInstanceSelector:(SEL)originalSelector
                 withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end