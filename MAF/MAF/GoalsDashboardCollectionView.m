//
//  GoalsDashboardCollectionView.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Goal.h"
#import "GoalsDashboardCollectionView.h"
#import "GoalDetailViewController.h"
#import "GoalCardView.h"
#import "ViewManager.h"

@interface GoalsDashboardCollectionView()

@property (strong, nonatomic) NSArray *_goals;
@property (strong, nonatomic) NSDictionary *_goalToPrettyDate;

@end

@implementation GoalsDashboardCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        UINib *cellNib = [UINib nibWithNibName:@"GoalCardView" bundle:nil];
        [self registerNib:cellNib forCellWithReuseIdentifier:@"GoalCardView"];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (GoalsDashboardCollectionView *)makeInstanceWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0];
    [flowLayout setMinimumLineSpacing:5.0];
    return [[GoalsDashboardCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self._goals count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (void)configureCell:(GoalCardView *)cell atIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = self._goals[indexPath.item];
    cell.goal = goal;
    cell.prettyDueDate = self._goalToPrettyDate[goal.objectId];
}

- (GoalCardView *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoalCardView *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GoalCardView" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(152, 242);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = self._goals[indexPath.item];
    [self.dashboardDelegate didSelectGoal:goal];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(7, 5, 7, 5);
}


#pragma mark Public Methods

- (void)setGoals:(NSArray *)goals {
    self._goals = goals;
    [self reloadData];
}

- (void)setGoalToPrettyDate:(NSDictionary *)goalToPrettyDate {
    self._goalToPrettyDate = goalToPrettyDate;
}

@end
