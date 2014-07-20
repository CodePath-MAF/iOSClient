//
//  OpenSansExtraBold.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansExtraBoldLabel.h"

@implementation OpenSansExtraBoldLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-ExtraBold" size:self.font.pointSize];
}

@end
