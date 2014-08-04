//
//  NewDashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/31/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "PNChart.h"

#import "DashboardTransactionsEmptyView.h"
#import "DashboardViewController.h"
#import "GoalsDashboardCollectionView.h"
#import "GoalDetailViewController.h"
#import "MultiInputViewController.h"
#import "MainViewController.h"
#import "ViewManager.h"
#import "Utilities.h"

@interface DashboardViewController () <DashboardTransactionsEmptyViewDelegate, GoalsDashboardCollectionViewDelegate, PNChartDelegate>

@property (strong, nonatomic) NSDictionary *viewData;
@property (weak, nonatomic) IBOutlet UIButton *addTransactionButton;

@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIView *goalsContainer;

@property (strong, nonatomic) DashboardTransactionsEmptyView *transactionsEmptyView;
@property (strong, nonatomic) GoalsDashboardCollectionView *goalsCollectionView;

@property (strong, nonatomic) PNLineChart *lineChart;

- (IBAction)addTransaction:(id)sender;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addTransactionButton.hidden = YES;
    [self _configureNavigationBar];
    self.title = @"Dashboard";
    
    [[[ViewManager instance] fetchViewData:@"dashboardView"] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error fetching dashboard view");
        } else {
            [self renderView:task.result];
        }
        return task;
    }];
}

- (void)renderView:(NSDictionary *)viewData {
    self.viewData = viewData;
    if ([(NSArray *)self.viewData[@"lineChart"][@"data"] count]) {
        [self _renderTransactionsView];
        [self _renderGoalsCollectionView];
    } else {
        [self _renderTransactionsEmptyView];
    }

}

- (void)_configureNavigationBar {
    
    // Set Up Profile Button
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_profile_up"] style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(@"_profileAction")];
    [profileButton setImageInsets:UIEdgeInsetsMake(8.0f, 0, 0, 0)];
    
    [profileButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_highlight"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    // Set Up Add Goal Button
    UIBarButtonItem *goalButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add_white_up"] style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(@"_createGoal")];
    [goalButton setImageInsets:UIEdgeInsetsMake(8.0f, 0, 0, 0)];
    [goalButton setBackgroundImage:[UIImage imageNamed:@"btn_add_white_highlight"] forState:UIControlStateHighlighted style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = goalButton;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark Navigation Actions

- (void)_profileAction {
    [PFUser logOut];
    [[ViewManager instance] clearCache];
    [self.navigationController setViewControllers:@[[[MainViewController alloc] init]] animated:YES];
}

- (void)_createGoal {
    [self.navigationController pushViewController:[[MultiInputViewController alloc] initWithMultiInputType:Goal_Creation] animated:YES];
}

#pragma mark Render Views

- (void)_renderGoalsCollectionView {
    CGRect frame = CGRectMake(0, 0, self.goalsContainer.frame.size.width, self.goalsContainer.frame.size.height);
    self.goalsCollectionView = [GoalsDashboardCollectionView makeInstanceWithFrame:frame];
    self.goalsCollectionView.dashboardDelegate = self;
    [self.goalsCollectionView setGoalToPrettyDate:self.viewData[@"goalToPrettyDueDate"]];
    [self.goalsCollectionView setGoals:self.viewData[@"goals"]];
    [self.goalsContainer addSubview:self.goalsCollectionView];
}

- (void)_renderTransactionsView {
    [self _buildChart];    
    self.addTransactionButton.hidden = NO;
}

- (void)_renderTransactionsEmptyView {
    self.transactionsEmptyView = [[DashboardTransactionsEmptyView alloc] initWithFrame:self.chartView.frame];
    self.transactionsEmptyView.delegate = self;
    [self.chartView addSubview:self.transactionsEmptyView];
}

- (void)_buildChart {
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 144.0)];
    [self.lineChart setXLabels:self.viewData[@"lineChart"][@"xLabels"]];
    [self.lineChart setYLabelHeight:20.f];
    self.lineChart.showCoordinateAxis = YES;
    
    
    NSArray *dataArray = self.viewData[@"lineChart"][@"data"];
    PNLineChartData *data = [PNLineChartData new];
    data.inflexionPointColor = [UIColor colorWithRed:35/255.0f green:199/255.0f blue:161/255.0f alpha:1.0f];
    data.color = [UIColor colorWithRed:52/255.0f green:47/255.0f blue:51/255.0f alpha:1.0f];
    data.inflexionPointWidth = 15.0;
    data.inflexionPointStyle = PNLineChartPointStyleCycle;
    data.itemCount = self.lineChart.xLabels.count;
    data.getData = ^(NSUInteger index) {
        CGFloat yValue = [dataArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    self.lineChart.chartData = @[data];
    [self.lineChart strokeChart];
    [self.chartView addSubview:self.lineChart];
    self.lineChart.delegate = self;
}

#pragma mark DashboardTransactionsEmptyDelegate

- (void)addTransactionButtonTriggered:(id)sender {
    [self.navigationController pushViewController:[[MultiInputViewController alloc] initWithMultiInputType:Transaction_Creation] animated:YES];
}

- (IBAction)addTransaction:(id)sender {
    [self addTransactionButtonTriggered:sender];
}

#pragma mark GoalsDashboardCollectionViewDelegate

- (void)didSelectGoal:(Goal *)goal {
    [[[ViewManager instance] goalDetailViewForGoal:goal] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"error loading goal details, %@", task.error);
        } else {
            GoalDetailViewController *goalDetailViewController = [[GoalDetailViewController alloc] initWithNibName:@"GoalDetailViewController" bundle:[NSBundle mainBundle]];
            [goalDetailViewController setViewData:task.result];
            [self.navigationController pushViewController:goalDetailViewController animated:YES];
        }
        return nil;
    }];
}

#pragma mark PNChartDelegate

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex {
    NSLog(@"bye %f %f %i %i", point.x, point.y, lineIndex, pointIndex);
}

@end
