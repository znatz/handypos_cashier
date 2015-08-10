//
//  Shop.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/10.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "Shop.h"

@implementation Shop
-(Shop *) initWithID : (int) i name : (NSString *) n
{
    self = [super init];
    self.shopID = i;
    self.name   = n;
    return self;
}

@end
