//
//  MosaicAnimatorView.m
//  MAF
//
//  Created by Guy Morita on 8/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "MosaicAnimatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MosaicAnimatorView

+ (MosaicAnimatorView *)overlayMosaicAnimatorView:(UIView *)viewToPop withFrame:(CGRect)frame {
    MosaicAnimatorView *mos = [[MosaicAnimatorView alloc] initWithFrame:frame];
    mos.alpha = 0;
    mos.whiteBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 570)];
    mos.whiteBackground.backgroundColor = [UIColor whiteColor];
    [viewToPop addSubview:mos.whiteBackground];
    mos.whiteBackground.alpha = 0;
    [viewToPop addSubview:mos];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        mos.whiteBackground.alpha = 0.6;
        mos.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    return mos;
}

+ (void)finishOverlayAnimator: (MosaicAnimatorView *)mosaicView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        mosaicView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIView *imageBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self addSubview:imageBox];
    //Create the first status image and the indicator view
    UIImage *statusImage = [UIImage imageNamed:@"loader_00000_"];
    UIImageView *activityImageView = [[UIImageView alloc]
                                      initWithImage:statusImage];
    
    
    //Add more images which will be used for the animation
        
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"loader_00000_"],
                                         [UIImage imageNamed:@"loader_00001_"],
                                         [UIImage imageNamed:@"loader_00002_"],
                                         [UIImage imageNamed:@"loader_00003_"],
                                         [UIImage imageNamed:@"loader_00004_"],
                                         [UIImage imageNamed:@"loader_00005_"],
                                         [UIImage imageNamed:@"loader_00006_"],
                                         [UIImage imageNamed:@"loader_00007_"],
                                         [UIImage imageNamed:@"loader_00008_"],
                                         [UIImage imageNamed:@"loader_00009_"],
                                         [UIImage imageNamed:@"loader_00010_"],
                                         [UIImage imageNamed:@"loader_00011_"],
                                         [UIImage imageNamed:@"loader_00012_"],
                                         [UIImage imageNamed:@"loader_00013_"],
                                         [UIImage imageNamed:@"loader_00014_"],
                                         [UIImage imageNamed:@"loader_00015_"],
                                         [UIImage imageNamed:@"loader_00016_"],
                                         [UIImage imageNamed:@"loader_00017_"],
                                         [UIImage imageNamed:@"loader_00018_"],
                                         [UIImage imageNamed:@"loader_00019_"],
                                         [UIImage imageNamed:@"loader_00020_"],
                                         [UIImage imageNamed:@"loader_00021_"],
                                         [UIImage imageNamed:@"loader_00022_"],
                                         [UIImage imageNamed:@"loader_00023_"],
                                         [UIImage imageNamed:@"loader_00024_"],
                                         [UIImage imageNamed:@"loader_00025_"],
                                         [UIImage imageNamed:@"loader_00026_"],
                                         [UIImage imageNamed:@"loader_00027_"],
                                         [UIImage imageNamed:@"loader_00028_"],
                                         [UIImage imageNamed:@"loader_00029_"],
                                         [UIImage imageNamed:@"loader_00030_"],
                                         [UIImage imageNamed:@"loader_00031_"],
                                         [UIImage imageNamed:@"loader_00032_"],
                                         [UIImage imageNamed:@"loader_00033_"],
                                         [UIImage imageNamed:@"loader_00034_"],
                                         nil];
    
    
    //Set the duration of the animation (play with it
    //until it looks nice for you)
    activityImageView.animationDuration = 1.6;
    
    
    //Position the activity image view somewhere in
    //the middle of your current view
    activityImageView.frame = CGRectMake(
                                         self.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [imageBox addSubview:activityImageView];
}

// get a white border around it
// make it animate in like a modal
// make the background blur
// add a function for the ending


@end
