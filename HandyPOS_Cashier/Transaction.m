//
//  Transaction.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/04.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

-(Transaction *) initWithID : (int) i
                  receiptNo : (NSString *) r
                 payment_id : (NSString *) pid
{
    self = [super init];
    self.transactionID = i;
    self.receiptNo     = r;
    self.payment_id    = pid;
    return self;
}
@end
