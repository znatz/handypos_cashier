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
#import <FlatUIKit/FlatUIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Home () <APNumberPadDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *receiptNO;
@property (weak, nonatomic) IBOutlet UITextField *tableNO;
@property (weak, nonatomic) IBOutlet UITableView *receiptContents;
@end

@implementation Home
NSString * path;
NSURL    * url;
SystemSoundID home_soundID;

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
    
    /* Sound Setup */
    path=[[NSBundle mainBundle]pathForResource:@"click" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&home_soundID);
    
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
    
    AudioServicesPlaySystemSound(home_soundID);
    
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
    
    AudioServicesPlaySystemSound(home_soundID);
    
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
    NSString * result = [NSString stringWithFormat:@"合計：%@", [self setPrice:[self getRawTotalPriceFromReceipt:rs]]];
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
        
        FUIButton * back = [[FUIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 44.0f)];
        back.buttonColor = [UIColor turquoiseColor];
        back.shadowColor = [UIColor greenSeaColor];
        back.shadowHeight= 3.0f;
        back.titleLabel.font = [UIFont boldFlatFontOfSize:19];
        [back setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [back setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        [back setTitle:@"戻る" forState:UIControlStateNormal];
        [back addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGFloat parentWidth      = [self view].frame.size.width;
        FUIButton * advanced     = [[FUIButton alloc] initWithFrame:CGRectMake(parentWidth - 130.0f, 0.0f, 100.0f, 44.0f)];
        advanced.buttonColor     = [UIColor turquoiseColor];
        advanced.shadowColor     = [UIColor greenSeaColor];
        advanced.shadowHeight    = 3.0f;
        advanced.titleLabel.font = [UIFont boldFlatFontOfSize:19];
        [advanced setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [advanced setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        [advanced setTitle:@"お支払い" forState:UIControlStateNormal];
        [advanced addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:back];
        [cell.contentView addSubview:advanced];
        return cell;
    }
    
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ normal line
    Receipt * eachReceipt   = receipt[indexPath.row];
    cell.textLabel.text     = eachReceipt.goodsTitle;
    
    NSString * priceXcount  = [NSString stringWithFormat:@"%@ X", [self setPrice:eachReceipt.price]];
    priceXcount = [priceXcount rightJustify:50 with:@" "];
    priceXcount = [NSString stringWithFormat:@"%@%d", priceXcount, eachReceipt.kosu];
    
    cell.detailTextLabel.text = priceXcount;
    return cell;
}

-(NSString *)setPrice : (int) p {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja-JP"]];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@"￥"];
    NSString * result = [formatter stringFromNumber:[[NSNumber alloc] initWithInt:p]];
    return result;
}



@end