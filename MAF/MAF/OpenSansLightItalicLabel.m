//
//  OpenSansLightItalicLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansLightItalicLabel.h"

@implementation OpenSansLightItalicLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-LightItalic" size:self.font.pointSize];
}

@end
