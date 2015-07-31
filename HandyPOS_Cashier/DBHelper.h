//
//  DBHelper.h
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/07/31.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface DBHelper : NSObject
+ (FMDatabase *) getDBFromFile : (NSString *) filename ;
+ (void) removeUnusedTalbesFromDB : (NSString *) dbfile forgiveTable : (NSString *) tablename ;
+ (NSMutableArray *) getReceiptByReceiptNo : (NSString *) i ;
+ (NSMutableArray *) getReceiptByTableNo : (NSString *) i ;
@end
