//
//  Setup.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/10.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "Setup.h"
#import "NetworkManager.h"
#import "ReceiptPrinter.h"
#import "DBHelper.h"
#import "DefaultSettings.h"
#import "Home.h"
#import <FlatUIKit/FlatUIKit.h>

@interface Setup () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet FUIButton *submit;
@property (weak, nonatomic) IBOutlet FUITextField *receiptIP;
@property (weak, nonatomic) IBOutlet UIPickerView *shops_employees_picker;
@end

@implementation Setup

NSMutableArray * allShops;
NSMutableArray * allEmployees;
Shop           * defaultShop;
Employee       * defaultEmployee;
static BOOL runonce = NO;


-(void)setupDefaultEnvironment {
    if ([ReceiptPrinter testConnection:@"192.168.1.231"]) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle : nil
                                                      message : @"プリンター正常に接続しました"
                                                     delegate : self
                                            cancelButtonTitle : @"進む"
                                            otherButtonTitles : nil, nil];
        [av show];
        [DefaultSettings removeAllPrinterPath];
        [DefaultSettings saveIfNotExistsPrinterPath:@"192.168.1.231"];
    } else {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle : @"プリンター接続失敗しました"
                                                      message : @"IPアドレス再設定してください"
                                                     delegate : self
                                            cancelButtonTitle : @"再設定"
                                            otherButtonTitles : nil, nil];
        [av show];
    }
}

-(BOOL)validatePrinter {
    if ([ReceiptPrinter testConnection:_receiptIP.text]) {
        [DefaultSettings removeAllPrinterPath];
        [DefaultSettings saveIfNotExistsPrinterPath:_receiptIP.text];
        return YES;
    } else {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle : nil
                                                      message : @"プリンター接続失敗しました。"
                                                     delegate : self
                                            cancelButtonTitle : @"再設定"
                                            otherButtonTitles : nil, nil];
        [av show];
        return NO;
    }
}

-(IBAction)submit:(id)sender {
    
    // If connection is setup correctly in viewDidLoad, the connection is not closed. Even if the _receiptIP is not empty, the validation will succeed.
    if([self validatePrinter]) {
        Home * hv           = [self.storyboard instantiateViewControllerWithIdentifier:@"home_scene"];
        hv.shopName         = defaultShop.name;
        hv.employeeName     = defaultEmployee.name;
        [self presentViewController:hv animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    
    if (!runonce) {
        [self setupDefaultEnvironment];
        [NetworkManager fetchDBFile:@"Master.sqlite"];
        runonce = YES;
    }
    
    allShops            = [DBHelper getAllShops];
    defaultShop         = allShops[0];
    allEmployees        = [DBHelper getAllEmployeesByShopID:defaultShop.shopID];
    defaultEmployee     = allEmployees[0];
    [self uiSetup];
    
    [super viewDidLoad];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        defaultShop     = allShops[row];
        allEmployees    = [DBHelper getAllEmployeesByShopID:defaultShop.shopID];
        defaultEmployee = allEmployees[0];
        [_shops_employees_picker reloadAllComponents];
    } else {
        defaultEmployee = allEmployees[row];
    }
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        Shop * s        = allShops[row];
        return s.name;
    } else {
        Employee * e    = allEmployees[row];
        return e.name;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 2; }

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return allShops.count;
    } else {
        return allEmployees.count;
    }
}

- (void)tapHandler:(UIGestureRecognizer *)sender {
    [_receiptIP resignFirstResponder];
    NSLog(@"done");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_receiptIP resignFirstResponder];
    return 0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_receiptIP resignFirstResponder];
}

-(void) uiSetup {
    
    UITapGestureRecognizer * tapRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapRecogn.delegate                 = self;
    self.view.userInteractionEnabled   = YES;
    [self.view addGestureRecognizer:tapRecogn];
    
    _submit.buttonColor = [UIColor turquoiseColor];
    _submit.shadowColor = [UIColor greenSeaColor];
    _submit.shadowHeight= 3.0f;
    _submit.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [_submit setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_submit setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [_submit setTitle:@"進む" forState:UIControlStateNormal];
    [_submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    _shops_employees_picker.delegate    = self;
    _shops_employees_picker.dataSource  = self;
    _receiptIP.delegate                 = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
