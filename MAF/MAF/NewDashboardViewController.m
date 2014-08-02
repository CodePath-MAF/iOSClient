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
#import "MultiInputViewController.h"
#import "MainViewController.h"
#import "NewDashboardViewController.h"
#import "ViewManager.h"
#import "Utilities.h"

@interface NewDashboardViewController () <DashboardTransactionsEmptyViewDelegate>

@property (strong, nonatomic) DashboardTransactionsEmptyView *transactionsEmptyView;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (strong, nonatomic) NSDictionary *viewData;
@property (weak, nonatomic) IBOutlet UIButton *addTransactionButton;
- (IBAction)addTransaction:(id)sender;

@end

@implementation NewDashboardViewController

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
    [self.navigationController setViewControllers:@[[[MainViewController alloc] init]] animated:YES];
}

- (void)_createGoal {
    [self.navigationController pushViewController:[[MultiInputViewController alloc] init] animated:YES];
}

#pragma mark Render Views

- (void)_renderTransactionsView {
    [self _buildChart];
    
    [Utilities setupRoundedButton:self.addTransactionButton withCornerRadius:BUTTON_CORNER_RADIUS];
    self.addTransactionButton.hidden = NO;
    self.addTransactionButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.addTransactionButton.titleLabel.font.pointSize];
}

- (void)_renderTransactionsEmptyView {
    self.transactionsEmptyView = [[DashboardTransactionsEmptyView alloc] initWithFrame:self.chartView.frame];
    self.transactionsEmptyView.delegate = self;
    [self.chartView addSubview:self.transactionsEmptyView];
}

- (void)_buildChart {
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0.0, 20.0, SCREEN_WIDTH, 200.0)];
    [lineChart setXLabels:self.viewData[@"lineChart"][@"xLabels"]];
    [lineChart setYLabelHeight:20.f];
    lineChart.showCoordinateAxis = YES;
    
    
    NSArray *dataArray = self.viewData[@"lineChart"][@"data"];
    PNLineChartData *data = [PNLineChartData new];
    data.inflexionPointColor = [UIColor colorWithRed:35/255.0f green:199/255.0f blue:161/255.0f alpha:1.0f];
    data.color = [UIColor colorWithRed:52/255.0f green:47/255.0f blue:51/255.0f alpha:1.0f];
    data.inflexionPointWidth = 15.0;
    data.inflexionPointStyle = PNLineChartPointStyleCycle;
    data.itemCount = lineChart.xLabels.count;
    data.getData = ^(NSUInteger index) {
        CGFloat yValue = [dataArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChart.chartData = @[data];
    [lineChart strokeChart];
    [self.chartView addSubview:lineChart];
}

#pragma mark DashboardTransactionsEmptyDelegate

- (void)addTransactionButtonTriggered:(id)sender {
    [self.navigationController pushViewController:[[MultiInputViewController alloc] initWithMultiInputType:Transaction_Creation] animated:YES];
}

- (IBAction)addTransaction:(id)sender {
    [self addTransactionButtonTriggered:sender];
}
@end
