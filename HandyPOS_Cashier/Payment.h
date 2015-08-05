//
//  Payment.h
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/04.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment : NSObject
@property int paymentID;
@property int price;
@property int payment;
@property int changes;
@property NSString * time;
@property NSString * UUID;
-(Payment *) initWithID : (int) i
                  price : (int) p
                payment : (int) pmnt
                changes : (int) c
                   time : (NSString *) t
                   UUID : (NSString *) u;
@end
