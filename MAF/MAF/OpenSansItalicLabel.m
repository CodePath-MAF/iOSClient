//
//  OpenSansItalicLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansItalicLabel.h"

@implementation OpenSansItalicLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-Italic" size:self.font.pointSize];
}

@end
