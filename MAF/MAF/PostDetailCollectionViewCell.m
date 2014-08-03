//
//  PostDetailReusableView.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "PostDetailCollectionViewCell.h"

@interface PostDetailCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *_postContentLabel;


@end

@implementation PostDetailCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPost:(Post *)post {
    _post = post;
    self._postContentLabel.text = post.content;
}

@end
