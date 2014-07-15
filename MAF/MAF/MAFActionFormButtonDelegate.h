//
//  MAFActionFormButtonDelegate.h
//  MAF
//
//  Created by mhahn on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLForm.h"

@protocol MAFActionFormButtonDelegate <NSObject>

@required
- (void)didSelectButton;

@end
