//
//  CreateTransactionForm.h
//  MAF
//
//  Created by mhahn on 7/7/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

#import "Transaction.h"

@interface CreateTransactionForm : NSObject <FXForm>

@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) enum TransactionType transactionType;
@property (nonatomic, assign) NSInteger amountInCents;

@end
