//
//  MAFActionFormButtonCell.m
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "MAFActionFormButtonCell.h"
#import "XLFormViewController_MAFActionFormButton.h"

@implementation MAFActionFormButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

#pragma mark - XLFormDescriptorCell

- (void)update {
    [super update]; 
    self.textLabel.text = self.rowDescriptor.title;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    [controller didSelectButton];
}

@end
