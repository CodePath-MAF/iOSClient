//
//  PostCollectionViewCell.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "MessageCollectionViewCell.h"
#import "OpenSansRegularLabel.h"
#import "Utilities.h"

@interface MessageCollectionViewCell()

@property (weak, nonatomic) IBOutlet OpenSansRegularLabel *_messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *_commentsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *_profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *_postTypeButton;
@property (weak, nonatomic) IBOutlet UIImageView *_commentsCountImage;

@end

@implementation MessageCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utilities setupRoundedButton:self._postTypeButton withCornerRadius:5.0];
    self._postTypeButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:self._postTypeButton.titleLabel.font.pointSize];
}

- (void)setPost:(Post *)post {
    _post = post;
    self._messageContentLabel.text = post.content;
    self._profileImageView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"profile_%ld", (long)post.user.profileImageId, nil]];
    if ([[post getComments] count]) {
        self._commentsCountImage.hidden = NO;
        self._commentsCountLabel.hidden = NO;
        self._commentsCountLabel.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)[[post getComments] count], nil];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self._commentsCountLabel.text = @"";
    self._commentsCountLabel.hidden = YES;
    self._commentsCountImage.hidden = YES;
    self.post = nil;
}

@end
