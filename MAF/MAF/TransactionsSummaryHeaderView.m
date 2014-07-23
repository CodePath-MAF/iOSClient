//
//  TransactionsSummaryTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "PNChart.h"

#import "OpenSansSemiBoldLabel.h"

#import "TransactionsSummaryHeaderView.h"
#import "TransactionCategoryManager.h"
#import "Utilities.h"
#import "PNStackedBarChartDataItem.h"
#import "User.h"

@interface TransactionsSummaryHeaderView() {
    NSDictionary *_transactionsTotalByCategoryByDate;
    float _maxValue;
    NSDateFormatter *_dateFormatter;
}


@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *spentThisWeekTotalLabel;

@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *totalCashLabel;
@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *spentTodayTotalLabel;

@property (nonatomic, strong) PNStackedBarChart *transactionsCategoryChart;

- (NSArray *)getDataItemsForDate:(NSDate *)date;

@end

@implementation TransactionsSummaryHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TransactionsSummaryHeaderView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.transactionsSet) {
        
        _transactionsTotalByCategoryByDate = [self.transactionsSet transactionsTotalByCategoryByDate];
        _maxValue = 0;
        
        NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
        NSArray *previousDates = [Utilities getPreviousDates:7 fromDate:today];
        _dateFormatter = [[NSDateFormatter alloc] init];
    #warning make sure the chart x labels support mutlilines
        [_dateFormatter setDateFormat:@"EEE\r(M/d)"];
        NSMutableArray *chartXLabels = [[NSMutableArray alloc] init];
        NSMutableArray *chartDataItems = [[NSMutableArray alloc] init];
        
        for (NSDate *previousDate in [previousDates reverseObjectEnumerator]) {
            [chartXLabels addObject:[_dateFormatter stringFromDate:previousDate]];
            [chartDataItems addObject:[self getDataItemsForDate:previousDate]];
        }
        
        self.transactionsCategoryChart = [[PNStackedBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175) itemArrays:chartDataItems];
        [self.transactionsCategoryChart setXLabels:chartXLabels];
        [self.transactionsCategoryChart setYMaxValue:_maxValue];
        [self.transactionsCategoryChart strokeChart];
        [self setActiveBar:6 activeAlpha:1.0f inactiveAlpha:0.5f];
        [self addSubview:self.transactionsCategoryChart];
        
    }
}

- (NSArray *)getDataItemsForDate:(NSDate *)date {
    NSDictionary *categoriesForDate = _transactionsTotalByCategoryByDate[date];
    NSArray *categories = [[TransactionCategoryManager instance] categories];
    NSMutableArray *dataItems = [[NSMutableArray alloc] init];
    float dateTotal = 0;
    for (TransactionCategory *category in categories) {
        float categoryTotal = [(NSNumber *)[categoriesForDate objectForKey:category.name] floatValue] ?: 0;
        if (categoryTotal) {
            dateTotal += categoryTotal;
            PNStackedBarChartDataItem *item = [PNStackedBarChartDataItem dataItemWithValue:categoryTotal color:[[TransactionCategoryManager instance] colorForCategory:category]];
            [dataItems addObject:item];
        }
    }
    if (dateTotal > _maxValue) {
        _maxValue = dateTotal;
    }
    return dataItems;
}

- (void)setTransactionsSet:(TransactionsSet *)transactionsSet {
    _transactionsSet = transactionsSet;
    self.spentThisWeekTotalLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", [transactionsSet spentThisWeek]];
    self.spentTodayTotalLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", [transactionsSet spentToday]];
    self.totalCashLabel.text = [[NSString alloc] initWithFormat:@"$%.02f", [[User currentUser] totalCash]];
}

- (void)setActiveBar:(NSInteger)barIndex activeAlpha:(CGFloat)activeAlpha inactiveAlpha:(CGFloat)inactiveAlpha {

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        for (int i = 0; i < self.transactionsCategoryChart.bars.count; i++) {
            UILabel *label = self.transactionsCategoryChart.labels[i];
            [label setTextColor:[Utilities colorFromHexString:@"#342F33"]];
            UIView *bar = self.transactionsCategoryChart.bars[i];
            if (i == barIndex) {
                label.alpha = activeAlpha;
                [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:10.f]];
                bar.alpha = activeAlpha;
            } else {
                label.alpha = inactiveAlpha;
                [label setFont:[UIFont fontWithName:@"OpenSans" size:10.f]];
                bar.alpha = inactiveAlpha;
            }
        }
    } completion:nil];
}

@end
