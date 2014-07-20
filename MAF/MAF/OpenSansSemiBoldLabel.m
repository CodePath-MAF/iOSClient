//
//  OpenSansSemiBoldLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansSemiBoldLabel.h"

@implementation OpenSansSemiBoldLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self.font.pointSize];
}

@end
