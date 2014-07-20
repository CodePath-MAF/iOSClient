//
//  OpenSansSemiBoldItalicLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansSemiBoldItalicLabel.h"

@implementation OpenSansSemiBoldItalicLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:self.font.pointSize];
}

@end
