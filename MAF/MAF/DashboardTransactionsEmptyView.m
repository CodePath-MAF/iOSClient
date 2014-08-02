//
//  DashboardTransactionsEmptyView.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "DashboardTransactionsEmptyView.h"
#import "Utilities.h"

@interface DashboardTransactionsEmptyView()

@property (weak, nonatomic) IBOutlet UIButton *addTransactionButton;
- (IBAction)addTransactionButtonTriggered:(id)sender;

@end

@implementation DashboardTransactionsEmptyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    [self _loadCustomNib];
    [self _configureDefaults];
}

- (void)_configureDefaults {
    [Utilities setupRoundedButton:self.addTransactionButton withCornerRadius:BUTTON_CORNER_RADIUS];
    self.addTransactionButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:self.addTransactionButton.titleLabel.font.pointSize];
}

- (void)_loadCustomNib {
    UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"DashboardTransactionsEmptyView" owner:self options:nil] firstObject];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:subView];
    
    // anchor the child view to the four edges of the container
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(subView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:viewsDictionary]];
}

- (IBAction)addTransactionButtonTriggered:(id)sender {
    [self.delegate addTransactionButtonTriggered:sender];
}
@end
