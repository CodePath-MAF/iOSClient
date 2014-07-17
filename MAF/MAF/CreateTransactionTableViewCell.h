//
//  CreateTransactionTableViewCell.h
//  MAF
//
//  Created by Guy Morita on 7/15/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTransactionTableViewCell : UITableViewCell

- (void)updateCell:(NSString *)mainLabel subLabel:(NSString *)subLabel;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end
