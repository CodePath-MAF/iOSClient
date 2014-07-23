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

@interface TransactionsSummaryHeaderView() <PNChartDelegate> {
    NSDictionary *_transactionsTotalByCategoryByDate;
    float _maxValue;

    float _alphaBeforeTransform;
    CGPoint _centerBeforeTransform;
    NSDateFormatter *_dateFormatter;
    NSArray *_previousDates;
}


@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *spentThisWeekTotalLabel;

@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *totalCashLabel;
@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *spentTodayTotalLabel;

@property (nonatomic, strong) PNStackedBarChart *transactionsCategoryChart;
@property (nonatomic, strong) PNHorizontalStackedBarChart *transactionsDetailChart;

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

- (NSArray *)getDataItemsForDate:(NSDate *)date;
- (PNStackedBarChart *)buildStackedBarChart:(NSArray *)xLabels dataItems:(NSArray *)dataItems;
- (float)getMaxValueFromItems:(NSArray *)dataItems;
- (NSArray *)getXLabelsForHorizontalBar:(NSArray *)dataItems;
- (void)handleTouchInDetailBar:(id)sender;

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
        [self.transactionsCategoryChart removeFromSuperview];
        
        _transactionsTotalByCategoryByDate = [self.transactionsSet transactionsTotalByCategoryByDate];
        _maxValue = 0;
        
        NSDate *today = [Utilities dateWithoutTime:[NSDate new]];
        _previousDates = [Utilities getPreviousDates:7 fromDate:today];
        _dateFormatter = [[NSDateFormatter alloc] init];
    #warning make sure the chart x labels support mutlilines
        [_dateFormatter setDateFormat:@"EEE\r(M/d)"];
        NSMutableArray *chartXLabels = [[NSMutableArray alloc] init];
        NSMutableArray *chartDataItems = [[NSMutableArray alloc] init];
        
        for (NSDate *previousDate in [_previousDates reverseObjectEnumerator]) {
            [chartXLabels addObject:[_dateFormatter stringFromDate:previousDate]];
            [chartDataItems addObject:[self getDataItemsForDate:previousDate]];
        }
        
        self.transactionsCategoryChart = [[PNStackedBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175) itemArrays:chartDataItems];
        [self.transactionsCategoryChart setXLabels:chartXLabels];
        [self.transactionsCategoryChart setYMaxValue:_maxValue];
        [self.transactionsCategoryChart strokeChart];
        self.transactionsCategoryChart.delegate = self;
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


- (void)userClickedOnBarCharIndex:(NSInteger)barIndex {
    
    NSLog(@"Click on bar %@", @(barIndex));
    UIView *bar = [self.transactionsCategoryChart.bars objectAtIndex:barIndex];
    
    UILabel *label = [self.transactionsCategoryChart.labels objectAtIndex:barIndex];
    NSDate *previousDate = _previousDates[_previousDates.count - barIndex - 1];
    NSArray *items = [self getDataItemsForDate:previousDate];
    float total = [self getMaxValueFromItems:items];
    NSArray *labels = [self getXLabelsForHorizontalBar:items];
    
    
    NSLog(@"date: %@, items: %@, labels: %@", previousDate, items, labels);
    [bar removeFromSuperview];
    [self addSubview:bar];
//    [self addSubview:label];

    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transactionsCategoryChart.alpha = 0.f;
        
        _alphaBeforeTransform = bar.alpha;
        _centerBeforeTransform = bar.center;
        CGAffineTransform barTransform = CGAffineTransformMakeScale(250.f/bar.frame.size.height, 4);
        bar.transform = CGAffineTransformRotate(barTransform, 90 * M_PI / 180);
        
        bar.alpha = 1.f;
        bar.center = CGPointMake(self.center.x, self.center.y - 30);
        self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleTouchInDetailBar:)];
        [bar addGestureRecognizer:self.singleTap];
//        label.alpha = 1.f;
//        label.center = CGPointMake(self.center.x, self.center.y - 80);
//        [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:label.font.pointSize]];
#warning TODO need to transform the size after we move its position

    } completion:nil];
}

- (NSArray *)getXLabelsForHorizontalBar:(NSArray *)dataItems {
    float total = [self getMaxValueFromItems:dataItems];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
#warning TODO add like a 'referenceLabel' to PNStackedBarChartDataItem so we can pull the category from it
#warning TODO potentially add like a primary and secondary label so we can support multiline values
    for (PNStackedBarChartDataItem *item in dataItems) {
        [labels addObject:[NSString stringWithFormat:@"%.02f%%", (item.value/total*100)]];
    }
    return labels;
}

- (float)getMaxValueFromItems:(NSArray *)dataItems {
    float total = 0.0;
    for (PNStackedBarChartDataItem *item in dataItems) {
        total += item.value;
    }
    return total;
}

- (void)handleTouchInDetailBar:(id)sender {
    NSLog(@"touched big bar");
    UIView *bar = [(UITapGestureRecognizer *)sender view];
    [[(UITapGestureRecognizer *)sender view] removeGestureRecognizer:self.singleTap];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        bar.center = _centerBeforeTransform;
        bar.transform = CGAffineTransformIdentity;
        self.transactionsCategoryChart.alpha = 1;
        bar.alpha = _alphaBeforeTransform;

    } completion:^(BOOL finished) {
        [bar removeFromSuperview];
        [self.transactionsCategoryChart addSubview:bar];
    }];
}

@end
