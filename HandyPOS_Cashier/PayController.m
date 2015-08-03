//
//  PayController.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/03.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "PayController.h"
#import <FlatUIKit/FlatUIKit.h>

@interface PayController ()
@property (weak, nonatomic) IBOutlet UITextField *receivable;
@property (weak, nonatomic) IBOutlet UITextField *payment;
@property (weak, nonatomic) IBOutlet UITextField *change;
@end

@implementation PayController
int currentInput;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d", _receivable_amount);
    _receivable.text = [NSString stringWithFormat:@"%d",_receivable_amount];
    
    [self appendButton];
    
}

-(IBAction)numberButtonHandler:(id)sender {
    FUIButton * btn = (FUIButton *) sender;
    if (currentInput < 1000000) {
        if (btn.tag == 10) {
            currentInput *= 100;
        } else {
            currentInput *= 10;
            currentInput += btn.tag;
        }
        
        [self updatePayment];
    }
}

- (void) appendButton {
    /* Buton 1 ~ 9 */
    CGFloat leftMargin      = 15.0f;
    CGFloat topMargin       = 170.0f;
    CGFloat btnHeight       = 70.0f;
    CGFloat btnWidth        = 70.0f;
    CGFloat btnHeightWithMargin = 1.0f + btnHeight;
    CGFloat btnWidthWithMargin  = 1.0f + btnWidth;
    CGFloat left;
    CGFloat top;
    
    for (int row = 1; row < 4; row ++) {
        for (int col = 1; col < 4; col++) {
            CGFloat left = leftMargin     + (col - 1) * btnWidthWithMargin;
            CGFloat top  = topMargin      + (row - 1) * btnHeightWithMargin;
            FUIButton * btn = [[FUIButton alloc] initWithFrame:CGRectMake(left, top, btnWidth, btnHeight)];
            btn.buttonColor = [UIColor turquoiseColor];
            btn.shadowColor = [UIColor greenSeaColor];
            btn.shadowHeight= 3.0f;
            btn.titleLabel.font = [UIFont boldFlatFontOfSize:19];
            [btn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
            btn.tag = (row - 1) * 3 + col;
            [btn setTitle:[NSString stringWithFormat:@"%d", btn.tag] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(numberButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
            [[self view] addSubview:btn];
        }
    }
    
    /* Button 0 */
    left = leftMargin ;
    top  = topMargin  + 3 * btnHeightWithMargin;
    FUIButton * btn = [[FUIButton alloc] initWithFrame:CGRectMake(left, top, btnWidth, btnHeight)];
    btn.buttonColor = [UIColor turquoiseColor];
    btn.shadowColor = [UIColor greenSeaColor];
    btn.shadowHeight= 3.0f;
    btn.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [btn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    btn.tag = 0;
    [btn setTitle:@"0" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(numberButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:btn];
    
     /* Button 00 btn00 , tag : 10 */
    left = leftMargin + btnWidthWithMargin;
    top  = topMargin  + 3 * btnHeightWithMargin;
    FUIButton * btn00 = [[FUIButton alloc] initWithFrame:CGRectMake(left, top, btnWidth, btnHeight)];
    btn00.buttonColor = [UIColor turquoiseColor];
    btn00.shadowColor = [UIColor greenSeaColor];
    btn00.shadowHeight= 3.0f;
    btn00.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [btn00 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [btn00 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    btn00.tag = 10;
    [btn00 setTitle:@"00" forState:UIControlStateNormal];
    [btn00 addTarget:self action:@selector(numberButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:btn00];
    
    /* Submit Button btn11 tag : 11 */
    left = leftMargin + 2 * btnWidthWithMargin;
    top  = topMargin  + 3 * btnHeightWithMargin;
    FUIButton * btn11 = [[FUIButton alloc] initWithFrame:CGRectMake(left, top, btnWidth + btnWidthWithMargin, btnHeight)];
    btn11.buttonColor = [UIColor turquoiseColor];
    btn11.shadowColor = [UIColor greenSeaColor];
    btn11.shadowHeight= 3.0f;
    btn11.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [btn11 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [btn11 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    btn11.tag = 11;
    [btn11 setTitle:@"確認" forState:UIControlStateNormal];
    [[self view] addSubview:btn11];
    
     /* Return to Previous Page Button btn12 tag : 12 */
    left = leftMargin + 3 * btnWidthWithMargin;
    top  = topMargin  ;
    FUIButton * btn12 = [[FUIButton alloc] initWithFrame:CGRectMake(left, top, btnWidth, btnHeight)];
    btn12.buttonColor = [UIColor turquoiseColor];
    btn12.shadowColor = [UIColor greenSeaColor];
    btn12.shadowHeight= 3.0f;
    btn12.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [btn12 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [btn12 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    btn12.tag = 12;
    [btn12 setTitle:@"戻る" forState:UIControlStateNormal];
    [[self view] addSubview:btn12];
    
      /* ClearOne Button btn13 tag : 13 */
    left = leftMargin + 3 * btnWidthWithMargin;
    top  = topMargin  + btnHeightWithMargin;
    FUIButton * btn13 = [[FUIButton alloc] initWithFrame:CGRectMake(left, top, btnWidth, btnHeight)];
    btn13.buttonColor = [UIColor turquoiseColor];
    btn13.shadowColor = [UIColor greenSeaColor];
    btn13.shadowHeight= 3.0f;
    btn13.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [btn13 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [btn13 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    btn13.tag = 13;
    [btn13 setTitle:@"<-" forState:UIControlStateNormal];
    [[self view] addSubview:btn13];
    
      /* Changes Button btn14 tag : 14 */
    left = leftMargin + 3 * btnWidthWithMargin;
    top  = topMargin  + 2 * btnHeightWithMargin;
    FUIButton * btn14 = [[FUIButton alloc] initWithFrame:CGRectMake(left, top, btnWidth, btnHeight)];
    btn14.buttonColor = [UIColor turquoiseColor];
    btn14.shadowColor = [UIColor greenSeaColor];
    btn14.shadowHeight= 3.0f;
    btn14.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [btn14 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [btn14 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    btn14.tag = 14;
    [btn14 setTitle:@"お釣り" forState:UIControlStateNormal];
    [[self view] addSubview:btn14];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updatePayment {
    _payment.text = [NSString stringWithFormat:@"%d", currentInput];
}
@end
