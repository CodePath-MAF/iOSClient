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
@property (nonatomic, strong) PNTextChart *detailLabelsChart;

@property (nonatomic, strong) UIView *selectedBar;

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

- (NSArray *)getTextChartDataItemsForDate:(NSDate *)date {
    NSDictionary *categoriesForDate = _transactionsTotalByCategoryByDate[date];
    NSArray *categories = [[TransactionCategoryManager instance] categories];
    NSMutableArray *dataItems = [[NSMutableArray alloc] init];
    float dateTotal = 0;
    NSDictionary *item;
    for (TransactionCategory *category in categories) {
        float categoryTotal = [(NSNumber *)[categoriesForDate objectForKey:category.name] floatValue] ?: 0;
        if (categoryTotal) {
            dateTotal += categoryTotal;
            item = @{@"categoryTotal": @(categoryTotal), @"color": [[TransactionCategoryManager instance] colorForCategory:category], @"name": [category.name uppercaseString]};
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
    self.selectedBar = [self.transactionsCategoryChart.bars objectAtIndex:barIndex];
    
    UILabel *label = [self.transactionsCategoryChart.labels objectAtIndex:barIndex];
    NSDate *previousDate = _previousDates[_previousDates.count - barIndex - 1];
    NSArray *items = [self getTextChartDataItemsForDate:previousDate];
    float total = [self getMaxValueFromItems:items];
    NSArray *labels = [self getXLabelsForHorizontalBar:items];
    
    NSMutableArray *topLabels = [[NSMutableArray alloc] init];
    NSMutableArray *bottomLabels = [[NSMutableArray alloc] init];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *item = items[i];
        NSString *percentString = labels[i];
        [topLabels addObject:[PNTextChartLabelItem dataItemWithText:item[@"name"] font:[UIFont fontWithName:@"OpenSans" size:10.f] textColor:item[@"color"] textAlignment:NSTextAlignmentCenter labelHeight:30.f]];
        [bottomLabels addObject:[PNTextChartLabelItem dataItemWithText:percentString font:[UIFont fontWithName:@"OpenSans-Semibold" size:8.f] textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter labelHeight:45.f]];
    }
    
    NSLog(@"date: %@, items: %@, labels: %@", previousDate, items, labels);
    [self.selectedBar removeFromSuperview];
    [self addSubview:self.selectedBar];
//    [self addSubview:label];

    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transactionsCategoryChart.alpha = 0.f;
        self.detailLabelsChart.alpha = 1.f;
        
        _alphaBeforeTransform = self.selectedBar.alpha;
        _centerBeforeTransform = self.selectedBar.center;
        CGAffineTransform barTransform = CGAffineTransformMakeScale(250.f/self.selectedBar.frame.size.height, 4);
        self.selectedBar.transform = CGAffineTransformRotate(barTransform, 90 * M_PI / 180);
        
        self.selectedBar.alpha = 1.f;
        self.selectedBar.center = CGPointMake(self.center.x, self.center.y - 30);
        self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleTouchInDetailBar:)];
        [self.selectedBar addGestureRecognizer:self.singleTap];
//        label.alpha = 1.f;
//        label.center = CGPointMake(self.center.x, self.center.y - 80);
//        [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:label.font.pointSize]];
#warning TODO need to transform the size after we move its position

    } completion:^(BOOL finished) {
        self.detailLabelsChart = [[PNTextChart alloc] initWithFrame:CGRectMake(self.selectedBar.frame.origin.x - 30, self.selectedBar.frame.origin.y + 80, self.selectedBar.frame.size.width + 50, self.selectedBar.frame.size.height)];
        [self.detailLabelsChart setTopLabels:topLabels];
        [self.detailLabelsChart setBottomLabels:bottomLabels];
        [self.detailLabelsChart setTopLabelWidth:100.f];
        [self.detailLabelsChart setBottomLabelWidth:100.f];
        [self.detailLabelsChart strokeChart];
        self.detailLabelsChart.alpha = 0.f;
        [self addSubview:self.detailLabelsChart];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.detailLabelsChart.alpha = 1.f;
        } completion:nil];
    }];
}

- (NSArray *)getXLabelsForHorizontalBar:(NSArray *)dataItems {
    float total = [self getMaxValueFromItems:dataItems];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
#warning TODO add like a 'referenceLabel' to PNStackedBarChartDataItem so we can pull the category from it
#warning TODO potentially add like a primary and secondary label so we can support multiline values
    for (NSDictionary *item in dataItems) {
        [labels addObject:[NSString stringWithFormat:@"%.02f%%", ([(NSNumber *)item[@"categoryTotal"] floatValue]/total*100)]];
    }
    return labels;
}

- (float)getMaxValueFromItems:(NSArray *)dataItems {
    float total = 0.0;
    for (NSDictionary *item in dataItems) {
        total += [(NSNumber *)item[@"categoryTotal"] floatValue];
    }
    return total;
}

- (void)handleTouchInDetailBar:(id)sender {
    NSLog(@"touched big bar");
    UIView *bar = [(UITapGestureRecognizer *)sender view];
    [[(UITapGestureRecognizer *)sender view] removeGestureRecognizer:self.singleTap];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.detailLabelsChart.alpha = 0;
    } completion:^(BOOL finished) {
        [self.detailLabelsChart removeFromSuperview];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            bar.center = _centerBeforeTransform;
            bar.transform = CGAffineTransformIdentity;
            self.transactionsCategoryChart.alpha = 1;
            bar.alpha = _alphaBeforeTransform;
            
        }
                         completion:^(BOOL finished) {
                             [bar removeFromSuperview];
                             [self.transactionsCategoryChart addSubview:bar];
                         }];
    }];
   
}

- (void)cleanUpCharts {
    [self.detailLabelsChart removeFromSuperview];
    [self.transactionsCategoryChart removeFromSuperview];
    [self.selectedBar removeFromSuperview];
}

@end
