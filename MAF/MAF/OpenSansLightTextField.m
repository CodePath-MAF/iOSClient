//
//  OpenSansLightTextField.m
//  MAF
//
//  Created by mhahn on 7/21/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "OpenSansLightTextField.h"

@implementation OpenSansLightTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"OpenSans-Light" size:self.font.pointSize];
}

@end
