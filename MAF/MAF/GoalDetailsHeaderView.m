//
//  GoalDetailsHeaderView.m
//  MAF
//
//  Created by mhahn on 8/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "GoalDetailsHeaderView.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"

@interface GoalDetailsHeaderView()

@property (weak, nonatomic) IBOutlet UIView *_progressBar;
@property (weak, nonatomic) IBOutlet UIView *_goalInformationView;

@end

@implementation GoalDetailsHeaderView

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
    
    [UIView beginAnimations:@"" context:nil];
    
    if (layoutAttributes.progressiveness <= 0.3) {
        self._progressBar.alpha = 1;
    } else {
        self._progressBar.alpha = 0;
    }
    
    [UIView commitAnimations];
}

@end
