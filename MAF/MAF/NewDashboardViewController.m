//
//  NewDashboardViewController.m
//  MAF
//
//  Created by mhahn on 7/31/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "NewDashboardViewController.h"
#import "PNChart.h"
#import "ViewManager.h"

@interface NewDashboardViewController ()

@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (strong, nonatomic) NSDictionary *viewData;

@end

@implementation NewDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self _buildChart];
}

- (void)_buildChart {
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    [lineChart setXLabels:self.viewData[@"lineChart"][@"xLabels"]];
    
    NSArray *dataArray = self.viewData[@"lineChart"][@"data"];
    PNLineChartData *data = [PNLineChartData new];
    data.color = PNFreshGreen;
    data.itemCount = lineChart.xLabels.count;
    data.getData = ^(NSUInteger index) {
        CGFloat yValue = [dataArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChart.chartData = @[data];
    [lineChart strokeChart];
    [self.chartView addSubview:lineChart];
}

@end
