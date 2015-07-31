//
//  ViewController.m
//  HandyPOS_Cashier
//
//  Created by ZNAZT on 2015/07/31.
//  Copyright © 2015年 ZNATZ . All rights reserved.
//

#import "Home.h"
#import "NetworkManager.h"
#import "DBHelper.h"
#import "Receipt.h"
#import "NSString+Ruby.h"

@interface Home () <APNumberPadDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *receiptNO;
@property (weak, nonatomic) IBOutlet UITextField *tableNO;
@property (weak, nonatomic) IBOutlet UITableView *receiptContents;
@end

@implementation Home

NSInteger count_of_receipt_line;
NSMutableArray * receipt ;

- (void)viewDidLoad {
    [NetworkManager fetchAllDB];
    [super viewDidLoad];
    _receiptNO.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        [numberPad.leftFunctionButton setTitle:@"検索" forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad.leftFunctionButton.tag = 0;
        numberPad;
    });
    
    _tableNO.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        [numberPad.leftFunctionButton setTitle:@"検索" forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad.leftFunctionButton.tag = 1;
        numberPad;
    });
    
    _receiptContents.dataSource = self;
    _receiptContents.delegate   = self;
    _receiptContents.hidden     = YES;
    _titleLabel.text            = @"検索";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

 #pragma mark - APNumberPadDelegate
 
- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
     
     if (functionButton.tag == 0) {
         receipt = [DBHelper getReceiptByReceiptNo:_receiptNO.text];
         if (receipt.count > 0) {
             _tableNO.hidden    = YES;
             _receiptNO.hidden  = YES;
             _titleLabel.text   = @"レシート";
         }
     } else {
         receipt = [DBHelper getReceiptByTableNo:_tableNO.text];
         if (receipt.count > 0) {
             _tableNO.hidden    = YES;
             _receiptNO.hidden  = YES;
             _titleLabel.text   = @"レシート";
         }
     }
     count_of_receipt_line = receipt.count;
     [self.receiptNO resignFirstResponder];
     self.receiptContents.hidden    = NO;
     [self.receiptContents reloadData];
     [textInput insertText:@"検索中・・・"];
     
}

/* --------------------- TableView */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (count_of_receipt_line == 0) {
        return 0;
    }
    return 100;
}

- (NSString *) getTotalPriceFromReceipt:(NSMutableArray *) rs {
    int total = 0;
    for (Receipt * r in rs) {
        total += r.price * r.kosu;
    }
    NSString * result = [NSString stringWithFormat:@"合計：￥%d", total];
    result = [result rightJustify:50 with:@" "];
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ last second line
    if (indexPath.row == receipt.count) {
        cell.textLabel.text  = [self getTotalPriceFromReceipt:receipt];
        return cell;
    }
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ last line
    if (indexPath.row == receipt.count + 1) {
        
        UIButton * back     = [UIButton buttonWithType:UIButtonTypeCustom];
        [back addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
        [back setTitle:@"戻る" forState:UIControlStateNormal];
        [back setFrame:CGRectMake(12.0, 0.0, 80.0, 44.0)];
        [back.titleLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
        [back setBackgroundColor:[UIColor yellowColor]];
        
        UIButton * advanced = [UIButton buttonWithType:UIButtonTypeCustom];
        [advanced addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
        [advanced setTitle:@"支払い" forState:UIControlStateNormal];
        [advanced setFrame:CGRectMake([self.view frame].size.width - 120.0, 0.0, 80.0, 44.0)];
        [advanced.titleLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
        [advanced setBackgroundColor:[UIColor yellowColor]];
        
        [cell.contentView addSubview:back];
        [cell.contentView addSubview:advanced];
        return cell;
    }
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ show nothing if row overflow array
    if (indexPath.row > receipt.count) return cell;
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ normal line
    Receipt * eachReceipt   = receipt[indexPath.row];
    cell.textLabel.text     = eachReceipt.goodsTitle;
    
    NSString * priceXcount  = [NSString stringWithFormat:@"¥%d X", eachReceipt.price];
    priceXcount = [priceXcount rightJustify:80 with:@" "];
    priceXcount = [NSString stringWithFormat:@"%@%d", priceXcount, eachReceipt.kosu];
    
    cell.detailTextLabel.text = priceXcount;
    return cell;
}


-(IBAction) goback:(id)sender {
    _receiptContents.hidden = YES;
    _tableNO.hidden         = NO;
    _receiptNO.hidden       = NO;
    _titleLabel.text        = @"検索";
    
}

@end