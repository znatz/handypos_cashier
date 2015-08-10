//
//  Setup.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/10.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "Setup.h"
#import "NetworkManager.h"
#import "DBHelper.h"
#import "Home.h"
#import <FlatUIKit/FlatUIKit.h>

@interface Setup () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet FUIButton *submit;
@property (weak, nonatomic) IBOutlet FUITextField *receiptIP;
@property (weak, nonatomic) IBOutlet UIPickerView *shops_employees_picker;
@end

@implementation Setup

NSMutableArray * allShops;
NSMutableArray * allEmployees;
Shop           * defaultShop;
Employee       * defaultEmployee;

-(IBAction)submit:(id)sender {
    Home * hv           = [self.storyboard instantiateViewControllerWithIdentifier:@"home_scene"];
    hv.shopName         = defaultShop.name;
    hv.employeeName     = defaultEmployee.name;
    [self presentViewController:hv animated:YES completion:nil];
}

- (void)viewDidLoad {
    [NetworkManager fetchDBFile:@"Master.sqlite"];
    allShops            = [DBHelper getAllShops];
    defaultShop         = allShops[0]; //REMEMBER IT?
    allEmployees        = [DBHelper getAllEmployeesByShopID:defaultShop.shopID];
    defaultEmployee     = allEmployees[0];
    [super viewDidLoad];
    [self uiSetup];
    _shops_employees_picker.delegate    = self;
    _shops_employees_picker.dataSource  = self;
    
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

-(void) uiSetup {
    _submit.buttonColor = [UIColor turquoiseColor];
    _submit.shadowColor = [UIColor greenSeaColor];
    _submit.shadowHeight= 3.0f;
    _submit.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [_submit setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_submit setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [_submit setTitle:@"hi" forState:UIControlStateNormal];
    [_submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
