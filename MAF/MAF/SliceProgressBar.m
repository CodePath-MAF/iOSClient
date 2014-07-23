//
//  SliceProgressBar.m
//  MAF
//
//  Created by Eddie Freeman on 7/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "SliceProgressBar.h"
#import "ProgressDataSlice.h"
#import "SliceView.h"

@interface SliceProgressBar ()

@property (nonatomic) CGFloat total;
@property (nonatomic) UIView *contentView;
@property (nonatomic) CAShapeLayer *barLayer;
@property (nonatomic, readwrite) NSArray *items;

- (void)loadDefault;

- (ProgressDataSlice *)dataItemForIndex:(NSUInteger)index;

- (CAShapeLayer *)newBarLayerWithStrokeColor:(UIColor *)strokeColor
                                       grade:(CGFloat)grade;

@end

@implementation SliceProgressBar

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items withMaxValue:(float)maxValue withCurrentProgress:(CGFloat)currentProgress {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _items               = [NSArray arrayWithArray:items];
        _bars                = [[NSMutableArray alloc] init];
        _showViewBorder      = NO; // Not implemented
        _maxValue            = maxValue;
        _currentProgress     = currentProgress;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self strokeProgressBar];
}

- (CAShapeLayer *)newBarLayerWithStrokeColor:(UIColor *)strokeColor grade:(CGFloat)grade {
    
    CAShapeLayer *bar = [CAShapeLayer layer];
    bar.lineCap = kCALineCapButt;
    bar.fillColor = [[UIColor whiteColor] CGColor];
    bar.lineWidth = self.frame.size.height;
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(0, 0)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width * grade, 0)];
    
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    bar.path = progressline.CGPath;
    bar.strokeColor = [strokeColor CGColor];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [bar addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    bar.strokeEnd = 1.0;
    
    return bar;
}

- (void)loadDefault {
    [self.contentView removeFromSuperview];
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contentView];
    
    self.barLayer = [CAShapeLayer layer];
    [self.contentView.layer addSublayer:self.barLayer];
}

- (void)strokeBar {
    [self loadDefault];
    
    NSMutableArray *layers = [[NSMutableArray alloc] init];
    ProgressDataSlice *currentItem;
    CGFloat currentTotal = 0;
    for (int i = 0; i < self.items.count; i++) {
        
        currentItem = [self dataItemForIndex:i];
        currentTotal += currentItem.value;
        
        CGFloat grade = currentTotal / self.maxValue;
        CAShapeLayer *currentBarLayer = [self newBarLayerWithStrokeColor:currentItem.color grade:grade];
        [layers addObject:currentBarLayer];
    }
}

- (void)strokeProgressBar {
    NSLog(@"Stroking the Bar");
    // Add bar
    
    NSLog(@"currentProgress: %f", self.currentProgress);
    NSLog(@"maxValue: %f", self.maxValue);
    
    CGFloat adjustedWidth = (self.currentProgress/self.maxValue)*self.frame.size.width;
    
    NSLog(@"adjusted Width: %f", adjustedWidth);
    
    [self strokeBar];
    
//    SliceView *bar = [[SliceView alloc] initWithFrame:CGRectMake(adjustedWidth, 0, adjustedWidth, self.frame.size.height) items:self.items withMaxValue:self.maxValue];
    
    [self viewCleanupForCollection:_bars];
    
//    [_bars addObject:bar];
//    [bar strokeBar];
//    [self addSubview:bar];
}

- (void)updateProgress {
    NSLog(@"Updating Progress");
    // TODO add view
    
    // fling it in
    
    // animate alpha
    
    // Eat previous progress while growing the bar
}

- (ProgressDataSlice *)dataItemForIndex:(NSUInteger)index {
    return self.items[index];
}

- (void)updateProgressWithItems:(NSArray *)items {
    NSLog(@"Update Progress with Items");
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.items];
    self.items = [newArray arrayByAddingObjectsFromArray:items];
    [self updateProgress];
}
- (void)updateProgressWithItem:(ProgressDataSlice *)item {
    NSLog(@"Update Progress with Item");
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.items];
    self.items = [newArray arrayByAddingObject:item];
    [self updateProgress];
}

- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}
@end
