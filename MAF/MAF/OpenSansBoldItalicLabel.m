//
//  OpenSansBoldItalicLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansBoldItalicLabel.h"

@implementation OpenSansBoldItalicLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-BoldItalic" size:self.font.pointSize];
}

@end
