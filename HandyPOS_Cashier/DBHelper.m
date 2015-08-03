//
//  DBHelper.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/07/31.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "DBHelper.h"
#import "NSString+Ruby.h"
#import "Receipt.h"
#import <FMDatabase.h>

#define DB_FILE         @"Cashier.sqlite"

@implementation DBHelper
+ (FMDatabase *) getDBFromFile : (NSString *) filename {
    NSArray *paths  =   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   =   [paths objectAtIndex:0];
    FMDatabase *db  =   [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:filename]];
    return db;
}

+(NSMutableArray *) getReceiptByReceiptNo : (NSString *) i {
    
    Receipt * r;
    NSMutableArray * receipts = [[NSMutableArray alloc] init];
    FMDatabase * db = [self getDBFromFile:DB_FILE];
    FMResultSet * result;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM receipt_lines WHERE receiptNo = %@", i ];
    
    [db open];
    result = [db executeQuery:query];
    while ([result next]) {
        r = [[Receipt alloc] initWithID : [result stringForColumn:@"id"]
                                  tanto : [result stringForColumn:@"tantoID"]
                             goodsTitle : [result stringForColumn:@"goodsTitle"]
                                   kosu : [result intForColumn:@"kosu"]
                                   time : [result stringForColumn:@"time"]
                              receiptNo : [result stringForColumn:@"receiptNo"]
                                tableNO : [result stringForColumn:@"tableNO"]
                                  price : [result intForColumn:@"price"]];
        [receipts addObject:r];
    }
    [db close];
    return receipts;
}

+(NSMutableArray *) getReceiptByTableNo : (NSString *) i {
    
    Receipt * r;
    NSMutableArray * receipts = [[NSMutableArray alloc] init];
    FMDatabase * db = [self getDBFromFile:DB_FILE];
    FMResultSet * result;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM receipt_lines WHERE tableNO = %@", i ];
    
    [db open];
    result = [db executeQuery:query];
    while ([result next]) {
        r = [[Receipt alloc] initWithID : [result stringForColumn:@"id"]
                                  tanto : [result stringForColumn:@"tantoID"]
                             goodsTitle : [result stringForColumn:@"goodsTitle"]
                                   kosu : [result intForColumn:@"kosu"]
                                   time : [result stringForColumn:@"time"]
                              receiptNo : [result stringForColumn:@"receiptNo"]
                                tableNO : [result stringForColumn:@"tableNO"]
                                  price : [result intForColumn:@"price"]];
        [receipts addObject:r];
    }
    [db close];
    return receipts;
}

@end
