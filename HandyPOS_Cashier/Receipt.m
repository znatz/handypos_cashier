//
//  Receipt.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/07/31.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "Receipt.h"

@implementation Receipt
-(Receipt *) initWithID : (NSString *) i
                  tanto : (NSString *) t
             goodsTitle : (NSString *) g
                   kosu : (int) k
                   time : (NSString *) tm
              receiptNo : (NSString *) r
                tableNO : (NSString *) tbl
                  price : (int) p
{
    self            = [super init];
    self.ID         = i;
    self.tanto      = t;
    self.goodsTitle = g;
    self.kosu       = k;
    self.time       = tm;
    self.receiptNo  = r;
    self.tableNO    = tbl;
    self.price      = p;
    return self;
}
@end
