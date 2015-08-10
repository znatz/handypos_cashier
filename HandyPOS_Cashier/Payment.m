//
//  Payment.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/04.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "Payment.h"

@implementation Payment
-(Payment *) initWithID : (int) i
                  price : (int) p
                payment : (int) pmnt
                changes : (int) c
                   time : (NSString *) t
                   UUID : (NSString *) u
               shopName : (NSString *) s
           employeeName : (NSString *) n
{
    self = [super init];
    self.paymentID = i;
    self.price     = p;
    self.payment   = pmnt;
    self.changes   = c;
    self.time      = t;
    self.UUID      = u;
    self.shopName  = s;
    self.employeeName   = n;
    return self;
}

@end
