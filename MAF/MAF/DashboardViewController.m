//
//  NewDashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/31/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChart.h"

#import "UIColor+CustomColors.h"

#import "DashboardTransactionsEmptyView.h"
#import "DashboardViewController.h"
#import "GoalsDashboardCollectionView.h"
#import "GoalDetailViewController.h"
#import "SimpleGoalDetailViewController.h"
#import "MultiInputViewController.h"
#import "MainViewController.h"
#import "ViewManager.h"
#import "Utilities.h"
#import "TransactionsListViewController.h"

@interface DashboardViewController () <DashboardTransactionsEmptyViewDelegate, GoalsDashboardCollectionViewDelegate, PNChartDelegate>

@property (strong, nonatomic) NSDictionary *viewData;
@property (weak, nonatomic) IBOutlet UIButton *addTransactionButton;

@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIView *goalsContainer;

@property (strong, nonatomic) DashboardTransactionsEmptyView *transactionsEmptyView;
@property (strong, nonatomic) GoalsDashboardCollectionView *goalsCollectionView;

@property (strong, nonatomic) PNLineChart *lineChart;

@property (strong, nonatomic) UIView *transitionView;

- (IBAction)addTransaction:(id)sender;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addTransactionButton.hidden = YES;
    [self _configureNavigationBar];
    self.title = @"Dashboard";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[ViewManager instance] fetchViewData:@"dashboardView"] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error fetching dashboard view");
        } else {
            [self renderView:task.result];
        }
        return task;
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.transitionView removeFromSuperview];
    [self _cleanupViews];
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

- (void)_cleanupViews {
    [self.lineChart removeFromSuperview];
    [self.goalsCollectionView removeFromSuperview];
}

- (void)_renderGoalsCollectionView {
    CGRect frame = CGRectMake(0, 0, self.goalsContainer.frame.size.width, self.goalsContainer.frame.size.height);
    self.goalsCollectionView = [GoalsDashboardCollectionView makeInstanceWithFrame:frame];
    self.goalsCollectionView.dashboardDelegate = self;
    [self.goalsCollectionView setShowsHorizontalScrollIndicator:NO];
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
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 160.0)];
    self.lineChart.xLabelFont = [UIFont fontWithName:@"OpenSans-Semibold" size:11.0];
    self.lineChart.yLabelFont = [UIFont fontWithName:@"OpenSans" size:11.0];
    [self.lineChart setXLabels:self.viewData[@"lineChart"][@"xLabels"]];
    [self.lineChart setYLabelHeight:20.f];

    
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

- (void)bubblePop:(UIView *)bubble {
    CGAffineTransform circleTransform = CGAffineTransformMakeScale(80, 80);
    [self performSelector:@selector(fadeTransactions) withObject:nil afterDelay:0.1];

    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        bubble.layer.borderWidth = 1;
        bubble.transform = circleTransform;
    } completion:^(BOOL finished) {
    }];
}

- (void)fadeTransactions {
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.0;
    transition.type = kCATransitionFade;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    TransactionsListViewController *vc = [[TransactionsListViewController alloc] init];
    [self.navigationController pushViewController:[[TransactionsListViewController alloc] init] animated:NO];
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
            if (goal.type == 1) {
                GoalDetailViewController *goalDetailViewController = [[GoalDetailViewController alloc] initWithNibName:@"GoalDetailViewController" bundle:[NSBundle mainBundle]];
                [goalDetailViewController setViewData:task.result];
                [self.navigationController pushViewController:goalDetailViewController animated:YES];
            } else {
                SimpleGoalDetailViewController *simpleGoalDetailViewController = [[SimpleGoalDetailViewController alloc] initWithNibName:@"SimpleGoalDetailViewController" bundle:nil];
                [simpleGoalDetailViewController setViewData:task.result];
                [self.navigationController pushViewController:simpleGoalDetailViewController animated:YES];
            }
        }
        return nil;
    }];
}

#pragma mark PNChartDelegate

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex {
    CGPoint poi = [self.lineChart.pathPoints[0][pointIndex] CGPointValue];
    self.transitionView = [[UIView alloc] initWithFrame:CGRectMake(poi.x-8.5, poi.y+11.5, 17, 17)];
    self.transitionView.backgroundColor = [UIColor whiteColor];
    self.transitionView.layer.borderColor = [UIColor colorWithRed:35/255.0f green:199/255.0f blue:161/255.0f alpha:1.0f].CGColor;
    self.transitionView.layer.borderWidth = 2.0f;
    self.transitionView.layer.cornerRadius = 8.5;
    self.transitionView.layer.masksToBounds = YES;
    [self.view addSubview:self.transitionView];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [[NSString alloc] initWithFormat:@"%@, 2014", self.viewData[@"lineChart"][@"xLabels"][pointIndex]];
    
    NSDate *today = [Utilities dateWithoutTime:[[NSDate alloc] init]];
    NSDate *date = [Utilities dateWithoutTime:[dateFormatter dateFromString:dateString]];
    if ([date compare:today] > 0) {
        date = today;
    }
    self.nextDate = [Utilities dateWithoutTime:date];
    [self bubblePop:self.transitionView];
}

@end
