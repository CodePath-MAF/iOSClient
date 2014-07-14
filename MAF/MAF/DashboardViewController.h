//
//  DashboardViewController.h
//  MAF
//
//  Created by mhahn on 7/6/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DashBoardViewControllerDelegate <NSObject>

@optional
- (void)createTransaction:(id)sender;
- (void)viewTransactions:(id)sender;

@required
- (void)createGoal:(id)sender;
- (void)viewGoals:(id)sender;
- (void)showProfile:(id)sender;

@end

@interface DashboardViewController : UIViewController

@property (nonatomic, weak) id <DashBoardViewControllerDelegate> delegate;

@end
