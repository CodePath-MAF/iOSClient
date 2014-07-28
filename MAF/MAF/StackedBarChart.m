//
//  StackedBarChart.m
//  MAF
//
//  Created by mhahn on 7/27/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "StackedBarChart.h"
#import "Utilities.h"

@implementation StackedBarChart

+ (PNStackedBarChart *)buildChart:(NSDictionary *)chartData {
    NSMutableArray *chartDataItems = [[NSMutableArray alloc] init];
    
    // build the PNStackedBarChartDataItems
    for (NSArray *items in chartData[@"data"]) {
        NSMutableArray *currentItems = [[NSMutableArray alloc] init];
        for (NSDictionary *itemData in items) {
            PNStackedBarChartDataItem *item = [PNStackedBarChartDataItem dataItemWithValue:[(NSNumber *)itemData[@"categoryTotal"] floatValue] color:[Utilities colorFromHexString:itemData[@"categoryColor"]]];
            [currentItems addObject:item];
        }
        [chartDataItems addObject:currentItems];
    }
    
    // Setup the chart
    PNStackedBarChart *transactionsCategoryChart = [[PNStackedBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175) itemArrays:chartDataItems];
    [transactionsCategoryChart setXLabels:chartData[@"xLabels"]];
    [transactionsCategoryChart setYMaxValue:[(NSNumber *)chartData[@"maxValue"] floatValue]];
    [transactionsCategoryChart strokeChart];
    
    return transactionsCategoryChart;
}

@end
