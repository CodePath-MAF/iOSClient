//
//  NoGoalView.m
//  MAF
//
//  Created by Eddie Freeman on 7/21/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "NoGoalView.h"
#import "Utilities.h"

@interface NoGoalView ()
@property (weak, nonatomic) IBOutlet UIButton *addGoalButton;

@end

@implementation NoGoalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [Utilities setupRoundedButton:self.addGoalButton
                     withCornerRadius:BUTTON_CORNER_RADIUS];
    }
    return self;
}

- (IBAction)addGoal:(UIButton *)sender {
    
}

@end
