//
//  TransactionsSummaryTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "PNChart.h"

#import "TransactionsSummaryTableViewCell.h"
#import "TransactionCategoryManager.h"
#import "Utilities.h"
#import "PNStackedBarChartDataItem.h"

@interface TransactionsSummaryTableViewCell() {
    NSDictionary *_transactionsTotalByCategoryByDate;
    float _maxValue;
    NSDateFormatter *_dateFormatter;
}

@property (weak, nonatomic) IBOutlet UILabel *transactionsWeeklyTotalLabel;
@property (nonatomic, strong) PNStackedBarChart *transactionsCategoryChart;

- (NSArray *)getDataItemsForDate:(NSDate *)date;

@end

@implementation TransactionsSummaryTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    _transactionsTotalByCategoryByDate = [self.transactionsSet transactionsTotalByCategoryByDate];
    _maxValue = 0;
    
    NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
    NSArray *previousDates = [Utilities getPreviousDates:7 fromDate:today];
    _dateFormatter = [[NSDateFormatter alloc] init];
#warning make sure the chart x labels support mutlilines
    [_dateFormatter setDateFormat:@"EEE\r(M/d)"];
    NSMutableArray *chartXLabels = [[NSMutableArray alloc] initWithObjects:[_dateFormatter stringFromDate:today], nil];
    NSMutableArray *chartDataItems = [[NSMutableArray alloc] initWithObjects:[self getDataItemsForDate:today], nil];
    
    for (NSDate *previousDate in previousDates) {
        [chartXLabels addObject:[_dateFormatter stringFromDate:previousDate]];
        [chartDataItems addObject:[self getDataItemsForDate:previousDate]];
    }
    
    self.transactionsCategoryChart = [[PNStackedBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125.0) itemArrays:chartDataItems];
    [self.transactionsCategoryChart setXLabels:chartXLabels];
    [self.transactionsCategoryChart setYMaxValue:_maxValue];
    [self.transactionsCategoryChart strokeChart];
    [self addSubview:self.transactionsCategoryChart];
}

- (NSArray *)getDataItemsForDate:(NSDate *)date {
    NSDictionary *categoriesForDate = _transactionsTotalByCategoryByDate[date];
    NSArray *categories = [[TransactionCategoryManager instance] categories];
    NSMutableArray *dataItems = [[NSMutableArray alloc] init];
    for (TransactionCategory *category in categories) {
        float categoryTotal = [(NSNumber *)[categoriesForDate objectForKey:category.name] floatValue] ?: 0;
        if (categoryTotal) {
            if (categoryTotal > _maxValue) {
                _maxValue = categoryTotal;
            }
            PNStackedBarChartDataItem *item = [PNStackedBarChartDataItem dataItemWithValue:categoryTotal color:[[TransactionCategoryManager instance] colorForCategory:category]];
            [dataItems addObject:item];
        }
    }
    return dataItems;
    
}
                                    
- (void)setTransactionsSet:(TransactionsSet *)transactionsSet {
    _transactionsSet = transactionsSet;
    self.transactionsWeeklyTotalLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", [transactionsSet transactionsTotalForCurrentWeek]];
}

@end
