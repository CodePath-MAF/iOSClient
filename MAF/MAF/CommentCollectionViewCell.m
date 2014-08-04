//
//  CommentReusableView.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CommentCollectionViewCell.h"
#import "OpenSansSemiBoldLabel.h"
#import "OpenSansLightLabel.h"

@interface CommentCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *_commenterProfileImage;
@property (weak, nonatomic) IBOutlet OpenSansSemiBoldLabel *_commenterNameLabel;
@property (weak, nonatomic) IBOutlet OpenSansLightLabel *_commentContentLabel;


@end

@implementation CommentCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setComment:(Comment *)comment {
    _comment = comment;
    if (comment) {
        self._commentContentLabel.text = comment.content;
        self._commenterNameLabel.text = comment.user[@"name"];
        self._commenterProfileImage.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"profile_%ld", (long)comment.user.profileImageId]];
    }
}

- (void)prepareForReuse {
    self.comment = nil;
    self._commentContentLabel.text = @"";
    self._commenterNameLabel.text = @"";
    self._commenterProfileImage.image = [[UIImage alloc] init];
}

@end
