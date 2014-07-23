//
//  UIViewController+ActionProgressIndicator.h
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ActionProgressIndicator)

- (void)startProgress:(UINavigationController *)navigationController;
- (void)finishProgress:(UINavigationController *)navigationController;
- (void)finishProgress:(UINavigationController *)navigationController setViewControllers:(NSArray *)viewControllers;

@end
