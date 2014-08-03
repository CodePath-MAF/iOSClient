//
//  PostCollectionViewCell.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "MessageCollectionViewCell.h"

@interface MessageCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *_commentsCountLabel;

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
}

- (void)setPost:(Post *)post {
    _post = post;
    self.messageContentLabel.text = post.content;
    NSLog(@"num comments: %lu", [[post getComments] count]);
    if ([[post getComments] count]) {
        self._commentsCountLabel.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)[[post getComments] count], nil];
    }
#warning TODO configure labels
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self._commentsCountLabel.text = @"";
    self.post = nil;
}

@end
