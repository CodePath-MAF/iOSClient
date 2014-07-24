//
//  LendingSocialCell.m
//  MAF
//
//  Created by Eddie Freeman on 7/19/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "LendingSocialCell.h"
#import "OpenSansRegularLabel.h"
#import "Utilities.h"

@interface LendingSocialCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation LendingSocialCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFriend:(Friend *)friend {
    _friend = friend;
    
    self.nameLabel.text = friend.name;
    [self.nameLabel setFont:[UIFont fontWithName:@"OpenSans" size:11.f]];
    [self.nameLabel setTextColor:[Utilities colorFromHexString:@"#979797"]];

    [self.photoImageView setImage:friend.photo];
}

@end
