//
//  Employee.m
//  HandyPOS_Cashier
//
//  Created by 小泉 丈太 on 2015/08/10.
//  Copyright © 2015年 小泉 丈太. All rights reserved.
//

#import "Employee.h"

@implementation Employee

-(Employee *) initWithID : (int) i
                    name : (NSString *) n
                    shop : (int) s
{
    self = [super init];
    self.employeeID = i;
    self.name       = n;
    self.shop       = s;
    return self;
}
@end
