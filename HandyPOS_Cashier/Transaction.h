//
//  Transaction.h
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/04.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject
@property int transactionID;
@property NSString * receiptNo;
@property NSString * payment_id;
-(Transaction *) initWithID : (int) i
                  receiptNo : (NSString *) r
                 payment_id : (NSString *) pid;
@end
