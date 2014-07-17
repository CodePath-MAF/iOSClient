//
//  CreateTransactionViewController.h
//  MAF
//
//  Created by Guy Morita on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPickerView.h"

@interface CreateTransactionViewController : UIViewController <MyPickerViewDataSource, MyPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
- (id)initWithCategories:(NSMutableArray *)categories;
@end
