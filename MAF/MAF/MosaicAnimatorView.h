//
//  MosaicAnimatorView.h
//  MAF
//
//  Created by Guy Morita on 8/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MosaicAnimatorView : UIView

@property (strong, nonatomic) UIView *whiteBackground;

+ (MosaicAnimatorView *)overlayMosaicAnimatorView:(UIView *)viewToPop withFrame:(CGRect)frame;
+ (void)finishOverlayAnimator: (MosaicAnimatorView *)mosaicView;

@end
