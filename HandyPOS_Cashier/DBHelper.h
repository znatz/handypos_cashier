//
//  DBHelper.h
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/07/31.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "Payment.h"
#import "Transaction.h"

@interface DBHelper : NSObject

+ (void) prepareTransactionDatabase ;
+ (void) recordPayment : (Payment *) p withReceiptNumbers : (NSMutableArray *) rns ;
+ (void) cleanUPPaymentRecord ;

+ (FMDatabase *) getDBFromFile : (NSString *) filename ;
+ (NSMutableArray *) getReceiptByReceiptNo : (NSString *) i ;
+ (NSMutableArray *) getReceiptByTableNo : (NSString *) i ;
+(NSMutableArray *) getAllReceiptNumberInTable : (NSString *) i ;
@end
