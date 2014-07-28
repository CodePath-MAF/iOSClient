//
//  TextDetailChart.m
//  MAF
//
//  Created by mhahn on 7/27/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TextDetailChart.h"
#import "Utilities.h"

@implementation TextDetailChart

+ (PNTextChart *)buildChart:(NSArray *)chartItems belowFrame:(CGRect)frame {
    NSArray *labels = [self getXLabelsForHorizontalBar:chartItems];
    
    NSMutableArray *topLabels = [[NSMutableArray alloc] init];
    NSMutableArray *bottomLabels = [[NSMutableArray alloc] init];
    for (int i = 0; i < chartItems.count; i++) {
        NSDictionary *item = chartItems[i];
        NSString *percentString = labels[i];
        [topLabels addObject:[PNTextChartLabelItem dataItemWithText:[item[@"categoryName"] uppercaseString] font:[UIFont fontWithName:@"OpenSans" size:10.f] textColor:[Utilities colorFromHexString:item[@"categoryColor"]] textAlignment:NSTextAlignmentCenter labelHeight:30.f]];
        [bottomLabels addObject:[PNTextChartLabelItem dataItemWithText:percentString font:[UIFont fontWithName:@"OpenSans-Semibold" size:8.f] textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter labelHeight:45.f]];
    }
    PNTextChart *detailLabelsChart = [[PNTextChart alloc] initWithFrame:CGRectMake(frame.origin.x - 30, frame.origin.y + 80, frame.size.width + 50, frame.size.height)];
    [detailLabelsChart setTopLabels:topLabels];
    [detailLabelsChart setBottomLabels:bottomLabels];
    [detailLabelsChart setTopLabelWidth:100.f];
    [detailLabelsChart setBottomLabelWidth:100.f];
    [detailLabelsChart strokeChart];
    return detailLabelsChart;
}

+ (NSArray *)getXLabelsForHorizontalBar:(NSArray *)dataItems {
    float total = [self getMaxValueFromItems:dataItems];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    for (NSDictionary *item in dataItems) {
        [labels addObject:[NSString stringWithFormat:@"%.02f%%", ([(NSNumber *)item[@"categoryTotal"] floatValue]/total*100)]];
    }
    return labels;
}

+ (float)getMaxValueFromItems:(NSArray *)dataItems {
    float total = 0.0;
    for (NSDictionary *item in dataItems) {
        total += [(NSNumber *)item[@"categoryTotal"] floatValue];
    }
    return total;
}

@end
