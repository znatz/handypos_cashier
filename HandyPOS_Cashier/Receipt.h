//
//  Receipt.h
//  HandyPOS_Cashier
//
//  Created by 小泉 丈太 on 2015/07/31.
//  Copyright © 2015年 小泉 丈太. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Receipt : NSObject
@property NSString * ID;
@property NSString * tanto;
@property NSString * goodsTitle;
@property int kosu;
@property NSString * time;
@property NSString * receiptNo;
@property NSString * tableNO;
@property int price;
-(Receipt *) initWithID : (NSString *) i
                  tanto : (NSString *) t
             goodsTitle : (NSString *) g
                   kosu : (int) k
                   time : (NSString *) tm
              receiptNo : (NSString *) r
                tableNO : (NSString *) tbl
                  price : (int) p;
@end
