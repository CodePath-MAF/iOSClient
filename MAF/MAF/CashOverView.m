//
//  CashOverView.m
//  MAF
//
//  Created by Eddie Freeman on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CashOverView.h"
#import <Parse/Parse.h>

@interface CashOverView()

@property (weak, nonatomic) IBOutlet UILabel *currentUserEmailLabel;
- (IBAction)createGoal:(id)sender;
- (IBAction)createTransaction:(id)sender;
- (IBAction)viewGoals:(id)sender;
- (IBAction)viewTransactions:(id)sender;

@end

@implementation CashOverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)viewDidLoad {
    self.currentUserEmailLabel.text = [[PFUser currentUser] username];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
