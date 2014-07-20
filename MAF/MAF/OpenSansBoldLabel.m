//
//  OpenSansBoldFontLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansBoldLabel.h"

@implementation OpenSansBoldLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.font.pointSize];
}

@end
