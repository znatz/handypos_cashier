//
//  Shop.h
//  HandyPOS_Cashier
//
//  Created by 小泉 丈太 on 2015/08/10.
//  Copyright © 2015年 小泉 丈太. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property int shopID;
@property NSString * name;
-(Shop *) initWithID : (int) i name : (NSString *) n;
@end
