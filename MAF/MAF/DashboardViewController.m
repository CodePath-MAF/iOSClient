//
//  DashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//


#import "DashboardViewController.h"
#import "Bolts.h"
#import "GoalDetailViewController.h"
#import "GoalCardView.h"
#import "GoalManager.h"

@interface DashboardViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *goals;

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentViewController.title = @"Dashboard";
    
    // Set Up Collection View delegate & data source
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Stub Goals Cell
    
    // Create Assets View (Collection Section Header)
    
    //
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self fetchData] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error fetching goals for user: %@", task.error);
        } else {
            self.goals = [NSMutableArray arrayWithArray:task.result];
            [self.collectionView reloadData];
        }
        return task;
    }];
}

#pragma mark - Data Loading Methods

- (BFTask *)fetchData {
    return [GoalManager fetchGoalsForUser:[PFUser currentUser]];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.goals count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GoalCardView " forIndexPath:indexPath];
    
    // TODO Check if Goal has been Achieved, display if not
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - Collection View Delegates

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width - 20, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO custom transition into a Goal Detail View Controller
}

//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    return NO;
//}

#pragma mark - Collection View Layout Delegates

// TODO for custom movements and fun stuff

@end
