//
//  GoalDetailsHeaderView.h
//  MAF
//
//  Created by mhahn on 8/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoalDetailsHeaderViewDelegate <NSObject>

- (void)addPost:(NSString *)contents;

@end

@interface GoalDetailsHeaderView : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *viewData;
@property (nonatomic, strong) id<GoalDetailsHeaderViewDelegate> delegate;

@end
