//
//  ReceiptPrinter.h
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/07.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Payment.h"

@interface ReceiptPrinter : NSObject
+ (void) preparePrinter : (NSMutableArray *) receipts withPayment : (Payment *) p ;
@end
