//
//  Employee.h
//  HandyPOS_Cashier
//
//  Created by 小泉 丈太 on 2015/08/10.
//  Copyright © 2015年 小泉 丈太. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject
@property int employeeID;
@property NSString * name;
@property int shop;
-(Employee *) initWithID : (int) i
                    name : (NSString *) n
                    shop : (int) s;
@end
