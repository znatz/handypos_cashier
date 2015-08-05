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
#import "Payment.h"
#import "Transaction.h"
#import <FMDatabase.h>

#define DB_FILE                 @"Cashier.sqlite"
#define DB_TRANSACTION_FILE     @"Transaction.sqlite"

@implementation DBHelper

/* ------------------------------------------------------------ Handle Payment ----------------------------------------- */
+ (void) prepareTransactionDatabase {
    [self cleanUPPaymentRecord];
    FMDatabase * db = [self getDBFromFile:DB_TRANSACTION_FILE];
    [db open];
    [db executeStatements:@"CREATE TABLE IF NOT EXISTS transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, receiptNo TEXT, payment_id INTEGER);"];
    [db close];
    [db open];
    [db executeStatements:@"CREATE TABLE IF NOT EXISTS payments(id INTEGER PRIMARY KEY AUTOINCREMENT, price INTEGER, payment INTEGER, changes INTEGER, time TEXT, uuid TEXT);"];
    [db close];
}

+ (void) recordPayment : (Payment *) p withReceiptNumbers : (NSMutableArray *) rns {
    FMDatabase * db = [self getDBFromFile:DB_TRANSACTION_FILE];
    NSString * query;
    query = [NSString stringWithFormat:@"INSERT INTO payments (price, payment, changes, time, uuid) VALUES (%d, %d, %d, '%@', '%@')", p.price, p.payment, p.changes, p.time, p.uuid];
    [db open];
    [db executeStatements:query];
    [db close];
    
    for (NSString * rn in rns) {
        query = [NSString stringWithFormat:@"INSERT INTO transactions (receiptNo, payment_id) VALUES (%@, '%@')", rn, p.uuid];
        [db open];
        [db executeStatements:query];
        [db close];
    }
}

+ (void) cleanUPPaymentRecord {
    FMDatabase * db = [self getDBFromFile:DB_TRANSACTION_FILE];
    NSString * query;
    query = @"DROP TABLE transactions;";
    [db open];
    [db executeStatements:query];
    [db close];
    query = @"DROP TABLE payments;";
    [db open];
    [db executeStatements:query];
    [db close];
    return;
    
}

/* ------------------------------------------------------------ Handle Receipt ----------------------------------------- */
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

+(NSMutableArray *) getAllReceiptNumberInTable : (NSString *) i {
    
    NSMutableArray * receiptNumbers = [[NSMutableArray alloc] init];
    FMDatabase * db = [self getDBFromFile:DB_FILE];
    FMResultSet * result;
    NSString * query = [NSString stringWithFormat:@"SELECT DISTINCT receiptNo FROM receipt_lines WHERE tableNO = %@", i ];
    
    [db open];
    result = [db executeQuery:query];
    while ([result next]) {
        [receiptNumbers addObject:[result stringForColumn:@"receiptNo"]];
    }
    [db close];
    return receiptNumbers;
    
}
@end
