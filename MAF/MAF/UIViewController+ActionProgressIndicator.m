//
//  UIViewController+ActionProgressIndicator.m
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "UIViewController+ActionProgressIndicator.h"
#import "MRProgress.h"

@implementation UIViewController (ActionProgressIndicator)

- (void)startProgress:(UINavigationController *)navigationController {
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:navigationController.view title:@"" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [progressView setTintColor:[[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f]];
}

- (void)finishProgress:(UINavigationController *)navigationController {

    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:navigationController.view title:@"" mode:MRProgressOverlayViewModeCheckmark animated:YES];
    [progressView setTintColor:[[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f]];
    [self performBlock:^{
        [MRProgressOverlayView dismissAllOverlaysForView:navigationController.view animated:YES];
        [navigationController popViewControllerAnimated:YES];
    } afterDelay:0.5];

}

- (void)finishProgress:(UINavigationController *)navigationController setViewControllers:(NSArray *)viewControllers {
    
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:navigationController.view title:@"" mode:MRProgressOverlayViewModeCheckmark animated:YES];
    [progressView setTintColor:[[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f]];
    [self performBlock:^{
        [MRProgressOverlayView dismissAllOverlaysForView:navigationController.view animated:YES];
        [navigationController setViewControllers:viewControllers animated:YES];
    } afterDelay:0.5];
    
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
