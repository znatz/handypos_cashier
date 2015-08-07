//
//  ReceiptPrinter.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/07.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "ReceiptPrinter.h"
#import "CMP20DRIVER.h"
#import "Receipt.h"
#import "Payment.h"
#import "NSString+Ruby.h"
#import "Helper.h"

@implementation ReceiptPrinter

+(void) preparePrinter : (NSMutableArray *) receipts withPayment : (Payment *) p {
    CMP20DRIVER * printer = [[CMP20DRIVER alloc] initWithURL:@"192.168.1.231"];
    [printer printHeader];
    
    /* -------------------------------------- Print Body -------------------------------- */
    
    NSString * list_header  = @"品 名　     数 量 　    金 額\r\n";
    [printer normal_center:list_header];
    
    NSString * line = [[NSString alloc] init];
    
    for (Receipt * r in receipts) {
        
         line     = [NSString stringWithFormat:@"%@\r\n", r.goodsTitle];
         [printer normal_left:line];
         
         NSString * price_count = [NSString stringWithFormat:@"%d X %d", r.price, r.kosu];
         price_count = [price_count rightJustify:20 with:@" "];
         NSString * priceXcount = [Helper setToCurrency:r.price*r.kosu];
         priceXcount = [priceXcount rightJustify:11 with:@" "];
         
         line     = [NSString stringWithFormat:@"%@%@\r\n", price_count,priceXcount];
         
         [printer normal_left:line];
         
    }
         
    [printer double_width_left:@"\r\n"];
    
    NSString * total_price_line = [[Helper setToCurrency:p.price] rightJustify:11 with:@" "];
    total_price_line = [NSString stringWithFormat:@"%@%@\r\n", @"合計",total_price_line];
    
    [printer double_width_left:total_price_line];
    
    NSString * tax_amount = [Helper setToCurrency:5*p.price/100];
    tax_amount = [tax_amount rightJustify:25 with:@" "];
    tax_amount = [NSString stringWithFormat:@"%@%@)\r\n", @"(内税", tax_amount];
    [printer normal_left:tax_amount];
    
    NSString * payment = [Helper setToCurrency:p.payment];
    payment = [payment rightJustify:23 with:@" "];
    payment = [NSString stringWithFormat:@"%@%@\r\n", @"お預かり", payment];
    [printer normal_left:payment];
    
    NSString * changes = [Helper setToCurrency:p.changes];
    changes = [changes rightJustify:25 with:@" "];
    changes = [NSString stringWithFormat:@"%@%@\r\n\r\n", @"お釣り", changes];
    [printer normal_right:changes];
     
    
    
    /* --------------------------------------- Print Footer --------------------------*/
    [printer printTxtName:@"footer"];
    [printer close];
}

/*
 -(void) printContentsWith: (NSMutableArray *) ts syoukei : (NSMutableArray *) ss {
 
 TransferData * t = ts[0];
 Nebiki * n = [DataModels getNebikkiByReceiptNo:t.receiptNo];
 ReceiptSettings * r = [DataAzukari getReceiptSettings];
 
 
 NSString * date_receipt = [NSString stringWithFormat:@"%@     No.%@\r\n", [t.time substringToIndex:14], t.receiptNo];
 NSString * tantou       = [NSString stringWithFormat:@"No%@%@\r\n\r\n", t.tantoID, [DataModels getTantoNameByID:t.tantoID]];
 [self normal_left:date_receipt];
 [self normal_left:tantou];
 
 NSString * list_header  = @"品 名　     数 量 　    金 額\r\n";
 [self normal_center:list_header];
 
 int i;
 NSString * line = [[NSString alloc] init];
 
 for (i = 0; i<ss.count; i++ ) {
 Syoukei * s = ss[i];
 
 line     = [NSString stringWithFormat:@"%@\r\n", s.title];
 [self normal_left:line];
 
 NSString * price_count = [NSString stringWithFormat:@"%d X %d", s.price, s.kosu];
 price_count = [price_count rightJustify:20 with:@" "];
 NSString * priceXcount = [self setStringAsCurrency: [NSString stringWithFormat:@"%d",s.price*s.kosu]];
 priceXcount = [priceXcount rightJustify:11 with:@" "];
 
 line     = [NSString stringWithFormat:@"%@%@\r\n", price_count,priceXcount];
 
 [self normal_left:line];
 
 
 //        [self normal_left:line];
 }
 
 [self double_width_left:@"\r\n"];
 
 NSString * total_price_line = [[self setStringAsCurrency:n._goukei] rightJustify:11 with:@" "];
 total_price_line = [NSString stringWithFormat:@"%@%@\r\n", @"合計",total_price_line];
 
 [self double_width_left:total_price_line];
 
 NSString * tax_amount = [NSString stringWithFormat:@"%d",r.tax * [n._goukei intValue]/100];
 tax_amount = [self setStringAsCurrency:tax_amount];
 tax_amount = [tax_amount rightJustify:25 with:@" "];
 tax_amount = [NSString stringWithFormat:@"%@%@)\r\n", @"(内税", tax_amount];
 [self normal_left:tax_amount];
 
 NSString * azukari = [self setStringAsCurrency:n._azukari];
 azukari = [azukari rightJustify:23 with:@" "];
 azukari = [NSString stringWithFormat:@"%@%@\r\n", @"お預かり", azukari];
 [self normal_left:azukari];
 
 NSString * oturi = [self setStringAsCurrency:n._oturi];
 oturi = [oturi rightJustify:25 with:@" "];
 oturi = [NSString stringWithFormat:@"%@%@\r\n\r\n", @"お釣り", oturi];
 [self normal_right:oturi];
 
 }

*/
@end