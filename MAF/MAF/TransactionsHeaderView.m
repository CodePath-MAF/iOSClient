//
//  TransactionsHeaderView.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TransactionsHeaderView.h"
#import "OpenSansRegularLabel.h"
#import "Utilities.h"

@interface TransactionsHeaderView()

@property (weak, nonatomic) IBOutlet OpenSansRegularLabel *sectionTitleLabel;

@end

@implementation TransactionsHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TransactionsHeaderView" owner:self options:nil] lastObject];
        self.backgroundColor = [Utilities colorFromHexString:@"#342F33"];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.sectionTitleLabel.text = [title uppercaseString];
    self.sectionTitleLabel.textColor = [Utilities colorFromHexString:@"#FFFFFF"];
}

@end
