//
//  GoalCardView.h
//  MAF
//
//  Created by Eddie Freeman on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Goal.h"

@class GoalCard;

@interface GoalCardView : UICollectionViewCell

@property (nonatomic, strong) Goal *goal;

@end
