//
//  CreateTransactionTableViewCell.m
//  MAF
//
//  Created by Guy Morita on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CreateTransactionTableViewCell.h"

@implementation CreateTransactionTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(NSString *)mainLabel subLabel:(NSString *)subLabel {
    self.mainLabel.text = mainLabel;
    self.subLabel.text = subLabel;
}

@end
