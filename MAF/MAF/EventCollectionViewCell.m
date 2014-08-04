//
//  EventCollectionViewCell.m
//  MAF
//
//  Created by mhahn on 8/4/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "EventCollectionViewCell.h"
#import "OpenSansRegularLabel.h"

@interface EventCollectionViewCell()

@property (weak, nonatomic) IBOutlet OpenSansRegularLabel *_eventContentLabel;

@end

@implementation EventCollectionViewCell

- (void)prepareForReuse {
    self._eventContentLabel.text = @"";
}

- (void)setPost:(Post *)post {
    _post = post;
    self._eventContentLabel.text = post.content;
}

@end
