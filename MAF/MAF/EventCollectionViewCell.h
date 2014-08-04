//
//  EventCollectionViewCell.h
//  MAF
//
//  Created by mhahn on 8/4/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface EventCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Post *post;

@end
