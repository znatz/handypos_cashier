//
//  NetworkManager.h
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/07/31.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (void) uploadPaymentRecord ;
+ (void) fetchDBFile : (NSString *)dbfileName;
+ (NSString *) fetchAllDB ;

+ (void) uploadFile : (NSString *) dbfileName;
@end
