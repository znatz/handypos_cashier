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

#define DB_FILE         @"Master.sqlite"
#define GOODS_TABLE     @"BTSMAS"
#define RECEIPT_TABLE   @"DataFromIOs"

@implementation DBHelper
+ (FMDatabase *) getDBFromFile : (NSString *) filename {
    NSArray *paths  =   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   =   [paths objectAtIndex:0];
    FMDatabase *db  =   [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:filename]];
    return db;
}

+ (void) removeUnusedTalbesFromDB : (NSString *) dbfile forgiveTable : (NSMutableArray *) tablenames {
    
    NSMutableSet * keepTables      = [NSMutableSet setWithArray:tablenames];
    NSMutableSet * allTableNames   = [[NSMutableSet alloc] init];
    
    FMDatabase  * db = [self getDBFromFile:dbfile];
    FMResultSet * result;
    
    [db open];
    result = [db executeQuery:@"SELECT name FROM sqlite_sequence"];
    while ([result next]) {
        NSString * existTable = [result stringForColumn:@"name"];
        [allTableNames addObject:existTable];
    }
    [db close];
    
    [allTableNames minusSet:keepTables];
    
    for (NSString * removableTable in allTableNames) {
        [db open];
        NSLog(@"TO BE DELETE %@", removableTable);
        [db executeStatements:[@"DROP TABLE ":removableTable, nil]];
        [db close];
    }
}

+(NSMutableArray *) getReceiptByReceiptNo : (NSString *) i {
    
    Receipt * r;
    NSMutableArray * receipts = [[NSMutableArray alloc] init];
    FMDatabase * db = [self getDBFromFile:DB_FILE];
    FMResultSet * result;
    
    [db open];
    result = [db executeQuery:@"SELECT * FROM DataFromIOs WHERE receiptNo = ?", i ];
    while ([result next]) {
        r = [[Receipt alloc] initWithID : [result stringForColumn:@"id"]
                                  tanto : [result stringForColumn:@"tanto"]
                             goodsTitle : [result stringForColumn:@"goodsTitle"]
                                   kosu : [[result stringForColumn:@"kosu"] intValue]
                                   time : [result stringForColumn:@"time"]
                              receiptNo : [result stringForColumn:@"receiptNo"]
                                tableNO : [result stringForColumn:@"tableNO"] price:0];
        [receipts addObject:[self setPriceOfReceipt:r]];
    }
    [db close];
    return receipts;
}


+(Receipt *) setPriceOfReceipt : (Receipt *) r {
    FMDatabase * db = [self getDBFromFile:DB_FILE];
    FMResultSet * result;
    
    [db open];
    result = [db executeQuery:@"SELECT price FROM BTSMAS WHERE title = ?", r.goodsTitle ];
    while ([result next]) {
        r.price = [result intForColumn:@"price"];
    }
    [db close];
    return r;
    
}
@end
