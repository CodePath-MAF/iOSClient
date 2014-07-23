//
//  SliceProgressBar.h
//  MAF
//
//  Created by Eddie Freeman on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNStackedBarChartDataItem.h"

@interface SliceProgressBar : UIView

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items withMaxValue:(float)maxValue withCurrentProgress:(CGFloat)currentProgress ;

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, strong) NSMutableArray *bars;

- (void)updateProgressWithItems:(NSArray *)items;
- (void)updateProgressWithItem:(PNStackedBarChartDataItem *)item;

/*
 showViewBorder if the view border Line should be display
 */
@property (nonatomic) BOOL showViewBorder;

/*
 maxValue define the max value of the bar
 */
@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, assign) CGFloat currentProgress;

@end
