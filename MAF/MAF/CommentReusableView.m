//
//  CommentReusableView.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CommentReusableView.h"

@interface CommentReusableView()

@property (weak, nonatomic) IBOutlet UILabel *_commentContentLabel;

@end

@implementation CommentReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setComment:(Comment *)comment {
    _comment = comment;
    self._commentContentLabel.text = comment.content;
}

- (void)prepareForReuse {
    self.comment = nil;
    self._commentContentLabel.text = @"";
}

@end
