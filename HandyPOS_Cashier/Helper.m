//
//  Helper.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/04.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString *)setToCurrency : (int) c {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja-JP"]];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@"￥"];
    NSString * formatted          = [formatter stringFromNumber:[[NSNumber alloc] initWithInt:c]];
    return formatted;
}


@end
