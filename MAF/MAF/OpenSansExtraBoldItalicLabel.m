//
//  OpenSansExtraBoldItalicLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansExtraBoldItalicLabel.h"

@implementation OpenSansExtraBoldItalicLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-ExtraBoldItalic" size:self.font.pointSize];
}

@end
