//
//  OpenSansLightLabel.m
//  MAF
//
//  Created by mhahn on 7/20/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansLightLabel.h"

@implementation OpenSansLightLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-Light" size:self.font.pointSize];
}

@end
