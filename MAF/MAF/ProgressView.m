//
//  ProgressView.m
//  MAF
//
//  Created by mhahn on 7/23/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "ProgressView.h"
#import "PNChart.h"

@interface ProgressView()

@property (nonatomic, strong) PNHorizontalStackedBarChart *progressBarView;

@end

@implementation ProgressView

- (void)drawRect:(CGRect)rect {
    
    NSArray *items = @[
       [PNStackedBarChartDataItem dataItemWithValue:self.progress color:[[UIColor alloc] initWithRed:40.0f/255.0f green:199.0f/255.0f blue:157.0f/255.0 alpha:1.0f/1.0f]],
       [PNStackedBarChartDataItem dataItemWithValue:(self.total - self.progress) color:[UIColor clearColor]],
    ];
    self.progressBarView = [[PNHorizontalStackedBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 30) items:items];
    [self.progressBarView setMaxValue:self.total];
    self.progressBarView.showLabel = NO;
    [self.progressBarView strokeChart];
    //    self.progressBarView.delegate = self;
    [self addSubview:self.progressBarView];
}

@end
