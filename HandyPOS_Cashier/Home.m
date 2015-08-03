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
#import "PayController.h"

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
    count_of_receipt_line       = receipt.count;
    [super viewDidLoad];
    _receiptNO.inputView = ({
        APNumberPad *numberPad  = [APNumberPad numberPadWithDelegate:self];
        [numberPad.leftFunctionButton setTitle:@"検索" forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad.leftFunctionButton.tag = 0;
        numberPad;
    });
    
    _tableNO.inputView = ({
        APNumberPad *numberPad  = [APNumberPad numberPadWithDelegate:self];
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

/* "Search" Button Handler ---------------------*/
- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    
    receipt = [[NSMutableArray alloc] init];
    receipt = functionButton.tag == 0 ? [DBHelper getReceiptByReceiptNo:_receiptNO.text] : [DBHelper getReceiptByTableNo:_tableNO.text];
    if (receipt.count > 0) {
        [self showResult] ;
    } else {
        UIAlertView * av = [ [UIAlertView alloc]
                            initWithTitle : nil
                            message : @"該当するレシートが\r\n見つかりませんでした"
                            delegate : self
                            cancelButtonTitle : @"データー更新する"
                            otherButtonTitles : nil, nil];
        [av show];
        count_of_receipt_line = 0;
    }
    
    [_receiptContents reloadData];
    
}

/* Show List Handler ---------------------------*/
- (void) showResult {
    _tableNO.hidden    = YES;
    _receiptNO.hidden  = YES;
    _titleLabel.text   = @"レシート";
    [_receiptNO resignFirstResponder];
    [_tableNO resignFirstResponder];
    
    count_of_receipt_line           = receipt.count;
    self.receiptContents.hidden     = NO;
    [_receiptContents reloadData];
    
}

/* Retrieve Database Handler -------------------*/
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [NetworkManager fetchAllDB];
}

/* "Back" Button Handler ----------------------*/
-(IBAction) goback:(id)sender {
    _receiptContents.hidden = YES;
    _tableNO.hidden         = NO;
    _receiptNO.hidden       = NO;
    _titleLabel.text        = @"検索";
    count_of_receipt_line   = 0;
    receipt                 = nil;
    [_receiptContents reloadData];
    
    [NetworkManager fetchAllDB];
}

/* "Pay" Button Handler ------------------------*/
-(IBAction) pay:(id)sender {
    PayController * payScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"pay_scene"];
    payScene.receivable_amount = [self getRawTotalPriceFromReceipt:receipt];
    [self presentViewController:payScene animated:YES completion:nil];
}

/* ::: =======================================================================================TableView ==========:::*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (count_of_receipt_line == 0) {
        return 0;
    }
    return 20;
}

- (int) getRawTotalPriceFromReceipt:(NSMutableArray *) rs {
    int total = 0;
    for (Receipt * r in rs) {
        total += r.price * r.kosu;
    }
    return total;
}


- (NSString *) getTotalPriceFromReceipt:(NSMutableArray *) rs {
    NSString * result = [NSString stringWithFormat:@"合計：￥%d", [self getRawTotalPriceFromReceipt:rs]];
    result = [result rightJustify:30 with:@" "];
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > (receipt.count + 1)) {
        return 0.01f;
    } else {
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ show nothing if row overflow array
    if (indexPath.row > receipt.count + 1) return cell;
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ last second line
    if (indexPath.row == receipt.count) {
        cell.textLabel.text  = [self getTotalPriceFromReceipt:receipt];
        return cell;
    }
    
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ last line
    if (indexPath.row == (receipt.count + 1)) {
        
        
        UIButton * back     = [UIButton buttonWithType:UIButtonTypeCustom];
        [back addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
        [back setTitle:@"戻る" forState:UIControlStateNormal];
        [back setFrame:CGRectMake(12.0, 0.0, 80.0, 44.0)];
        [back.titleLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
        [back setBackgroundColor:[UIColor yellowColor]];
        
        UIButton * advanced = [UIButton buttonWithType:UIButtonTypeCustom];
        [advanced addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        [advanced setTitle:@"支払い" forState:UIControlStateNormal];
        [advanced setFrame:CGRectMake([self.view frame].size.width - 120.0, 0.0, 80.0, 44.0)];
        [advanced.titleLabel setFont:[UIFont boldSystemFontOfSize:21.0]];
        [advanced setBackgroundColor:[UIColor yellowColor]];
        
        [cell.contentView addSubview:back];
        [cell.contentView addSubview:advanced];
        return cell;
    }
    
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ normal line
    Receipt * eachReceipt   = receipt[indexPath.row];
    cell.textLabel.text     = eachReceipt.goodsTitle;
    
    NSString * priceXcount  = [NSString stringWithFormat:@"¥%d X", eachReceipt.price];
    priceXcount = [priceXcount rightJustify:50 with:@" "];
    priceXcount = [NSString stringWithFormat:@"%@%d", priceXcount, eachReceipt.kosu];
    
    cell.detailTextLabel.text = priceXcount;
    return cell;
}




@end