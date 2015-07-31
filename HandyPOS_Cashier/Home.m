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

@interface Home () <APNumberPadDelegate>
@property (weak, nonatomic) IBOutlet UITextField *receiptNO;
@property (weak, nonatomic) IBOutlet UITextField *tableNO;
@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkManager fetchAllDB];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

 #pragma mark - APNumberPadDelegate
 
 - (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    [textInput insertText:[NSString stringWithFormat:@"%ld", (long)functionButton.tag]];
     
    NSMutableArray * receipt = [DBHelper getReceiptByReceiptNo:@"45"];
    NSLog(@"count of %ld", receipt.count);
 }
@end