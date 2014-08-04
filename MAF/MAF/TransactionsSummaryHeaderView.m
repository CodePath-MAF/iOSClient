//
//  TransactionsSummaryTableViewCell.m
//  MAF
//
//  Created by mhahn on 7/16/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "PNChart.h"

#import "OpenSansSemiBoldLabel.h"

#import "StackedBarChart.h"
#import "TransactionsSummaryHeaderView.h"
#import "TransactionCategoryManager.h"
#import "Utilities.h"
#import "User.h"
#import "TextDetailChart.h"

@interface TransactionsSummaryHeaderView() <PNChartDelegate> {
    float _alphaBeforeTransform;
    CGPoint _barCenterBeforeTransform;
    CGRect _labelFrameBeforeTransform;
    UIFont *_labelFontBeforeTransform;
    float _labelAlphaBeforeTransform;
    UILabel *_activeLabel;
    PNStackedBar *_prototypeBar;
}

@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *spentThisWeekTotalLabel;
@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *totalCashLabel;
@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *spentTodayTotalLabel;

@property (nonatomic, strong) PNStackedBarChart *transactionsCategoryChart;
@property (nonatomic, strong) PNTextChart *detailLabelsChart;

@property (nonatomic, strong) NSDictionary *chartData;
@property (nonatomic, strong) PNStackedBar *selectedBar;

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

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
    [self.transactionsCategoryChart removeFromSuperview];
    [self renderStackedBarChart:self.viewData[@"stackedBarChart"]];
}

- (void)renderStackedBarChart:(NSDictionary *)chartData {
    self.transactionsCategoryChart = [StackedBarChart buildChart:chartData];
    self.transactionsCategoryChart.delegate = self;
    [self setActiveBar:6 activeAlpha:1.0f inactiveAlpha:0.5f];
    [self addSubview:self.transactionsCategoryChart];
}

- (void)renderTextDetailChart:(NSInteger)index chartData:(NSDictionary *)chartData {
    NSArray *items = [(NSArray *)chartData[@"data"] objectAtIndex:index];
    self.detailLabelsChart = [TextDetailChart buildChart:items belowFrame:_prototypeBar.frame];
    self.detailLabelsChart.alpha = 0.f;
    [self addSubview:self.detailLabelsChart];
}

- (void)setViewData:(NSDictionary *)viewData {
    _viewData = viewData;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.spentThisWeekTotalLabel.text = [numberFormatter stringFromNumber:(NSNumber *)viewData[@"spentThisWeek"]];
    self.spentTodayTotalLabel.text = [numberFormatter stringFromNumber:(NSNumber *)viewData[@"spentToday"]];
    self.totalCashLabel.text = [numberFormatter stringFromNumber:(NSNumber *)viewData[@"totalCash"]];
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
    
    self.selectedBar = [self.transactionsCategoryChart.bars objectAtIndex:barIndex];
    _activeLabel = [self.transactionsCategoryChart.labels objectAtIndex:barIndex];
    
    // copy the bar so we can get its frame after transform
    _prototypeBar = [[PNStackedBar alloc] initWithFrame:self.selectedBar.frame
                                                  items:self.selectedBar.items
                                           withMaxValue:self.selectedBar.maxValue];
    _prototypeBar.alpha = 0;
    [_prototypeBar strokeBar];
    [self transformBar:_prototypeBar];
    
    // remove the bar from the chart and add it to the main view
    [self.selectedBar removeFromSuperview];
    [self addSubview:self.selectedBar];
 
    // bring current label into focus
    _labelFrameBeforeTransform = _activeLabel.frame;
    _labelFontBeforeTransform = _activeLabel.font;
    [_activeLabel removeFromSuperview];
    [self addSubview:_activeLabel];

    // animate the detail view
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.transactionsCategoryChart.alpha = 0.f;
                            [self transformBar:self.selectedBar];
                            self.selectedBar.alpha = 1.f;
                            self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handleTouchInDetailBar:)];
                            [self.selectedBar addGestureRecognizer:self.singleTap];
#warning TODO we should have a "verbose" value for the day so we can substitute that here ie. Sun -> Sunday (July 27th)
                            _activeLabel.frame = CGRectMake(self.center.x - 10, self.center.y - 95, _activeLabel.frame.size.width + 10, _activeLabel.frame.size.height);
                            [_activeLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:15]];
                            _labelAlphaBeforeTransform = _activeLabel.alpha;
                            _activeLabel.alpha = 1.f;
                        }
                        completion:nil];
    
    // animate the detail labels
    [self renderTextDetailChart:barIndex chartData:self.viewData[@"stackedBarChart"]];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        self.detailLabelsChart.alpha = 1.f;
                     }
                     completion:nil];
}

- (void)transformBar:(UIView *)bar {
    _alphaBeforeTransform = bar.alpha;
    _barCenterBeforeTransform = bar.center;
    CGAffineTransform barTransform = CGAffineTransformMakeScale(250.f/bar.frame.size.height, 4);
    bar.transform = CGAffineTransformRotate(barTransform, 90 * M_PI / 180);
    bar.center = CGPointMake(self.center.x, self.center.y - 30);
}

- (void)handleTouchInDetailBar:(id)sender {
    UIView *bar = [(UITapGestureRecognizer *)sender view];
    [[(UITapGestureRecognizer *)sender view] removeGestureRecognizer:self.singleTap];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.detailLabelsChart.alpha = 0;
    } completion:^(BOOL finished) {
        [self.detailLabelsChart removeFromSuperview];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                            bar.center = _barCenterBeforeTransform;
                            bar.transform = CGAffineTransformIdentity;
                            self.transactionsCategoryChart.alpha = 1;
                            bar.alpha = _alphaBeforeTransform;
                            _activeLabel.frame = _labelFrameBeforeTransform;
                            _activeLabel.font = _labelFontBeforeTransform;
                            _activeLabel.alpha = _labelAlphaBeforeTransform;
                        }
                         completion:^(BOOL finished) {
                             [bar removeFromSuperview];
                             [self.transactionsCategoryChart addSubview:bar];
                             [_activeLabel removeFromSuperview];
                             [self.transactionsCategoryChart addSubview:_activeLabel];
                         }];
    }];
   
}

- (void)cleanUpCharts {
    [self.detailLabelsChart removeFromSuperview];
    [_activeLabel removeFromSuperview];
    [self.transactionsCategoryChart removeFromSuperview];
    [self.selectedBar removeFromSuperview];
}

@end
