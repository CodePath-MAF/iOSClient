//
//  GoalsDashboardCollectionView.h
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"

@protocol GoalsDashboardCollectionViewDelegate <NSObject>

- (void)didSelectGoal:(Goal *)goal;

@end

@interface GoalsDashboardCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) id<GoalsDashboardCollectionViewDelegate> dashboardDelegate;

- (void)setGoals:(NSArray *)goals;
- (void)setGoalToPrettyDate:(NSDictionary *)goalToPrettyDate;

+ (GoalsDashboardCollectionView *)makeInstanceWithFrame:(CGRect)frame;

@end
