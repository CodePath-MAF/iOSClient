//
//  CommentReusableView.h
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentReusableView : UICollectionViewCell

@property (nonatomic, strong) Comment *comment;

@end
