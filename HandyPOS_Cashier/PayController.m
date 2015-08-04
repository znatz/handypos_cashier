//
//  PayController.m
//  HandyPOS_Cashier
//
//  Created by ZNATZ on 2015/08/03.
//  Copyright © 2015年 ZNATZ. All rights reserved.
//

#import "PayController.h"
#import "Home.h"
#import "DBHelper.h"
#import "Helper.h"
#import "NetworkManager.h"
#import "Payment.h"
#import "Transaction.h"

#import <FlatUIKit/FlatUIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PayController ()
@property (weak, nonatomic) IBOutlet UITextField *receivable;
@property (weak, nonatomic) IBOutlet UITextField *payment;
@property (weak, nonatomic) IBOutlet UITextField *change;
@end

@implementation PayController

int currentInput;
int currentChanges;


NSString * sound_path;
NSURL    * sound_url;
SystemSoundID soundID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Data Setup */
    currentInput     = 0;
    currentChanges   = 0;
    _receivable.text = [Helper setToCurrency:_receivable_amount];
    _payment.text    = [NSString stringWithFormat:@"%d", 0];
    _change.text     = [NSString stringWithFormat:@"%d", 0];
    
    /* Button Setup */
    [self appendButton];
    
    /* Sound Setup */
    sound_path=[[NSBundle mainBundle]pathForResource:@"click" ofType:@"wav"];
    sound_url=[NSURL fileURLWithPath:sound_path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url,&soundID);
    
}

-(IBAction)submitButtonHandler:(id)sender {
    
    AudioServicesPlaySystemSound(soundID);
    
    [self validation];
    [DBHelper prepareTransactionDatabase];
    // id is dummnynow
    Payment * payment = [[Payment alloc] initWithID:0 price:_receivable_amount payment:currentInput changes:currentChanges time:[Helper getCurrentTime]];
    [DBHelper recordPayment:payment withReceiptNumbers:_receiptNumbers];
    [NetworkManager uploadPaymentRecord];
    [DBHelper cleanUPPaymentRecord];
}

-(IBAction)numberButtonHandler:(id)sender {
    
    AudioServicesPlaySystemSound(soundID);
    
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

-(IBAction)changesButtonHandler:(id)sender {
    
    AudioServicesPlaySystemSound(soundID);
    
    currentChanges = currentInput - self.receivable_amount;
    [self updateChanges];
}


-(IBAction)clearOneButtonHandler:(id)sender {
    
    AudioServicesPlaySystemSound(soundID);
    
    currentInput = ceilf(currentInput / 10);
    [self updatePayment];
}

-(IBAction)returnButtonHandler:(id)sender {
    
    AudioServicesPlaySystemSound(soundID);
    
    Home * homeScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"home_scene"];
    [self presentViewController:homeScene animated:YES completion:nil];
}


-(BOOL)validation {
    if (currentInput < _receivable_amount) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle : nil
                                                      message : @"入金が足りません。"
                                                     delegate : self
                                            cancelButtonTitle : @"再入力"
                                            otherButtonTitles : nil, nil];
        [av show];
        return NO;
    }
    if (currentInput - _receivable_amount != currentChanges) {
         UIAlertView * av = [[UIAlertView alloc] initWithTitle : nil
                                                      message : @"お釣りに間違いがあります。"
                                                     delegate : self
                                            cancelButtonTitle : @"再入力"
                                            otherButtonTitles : nil, nil];
        [av show];
        return NO;
    }
    return YES;
}


- (void) appendButton {
    
    CGFloat leftMargin      = 18.0f;
    CGFloat bottomMargin    = 5.0f;
    CGFloat btnMargin       = 1.0f;
    
    CGFloat parentWidth     = self.view.frame.size.width;
    CGFloat parentHeight    = self.view.frame.size.height;
    
    CGFloat btnWidth        = (parentWidth - 2 * leftMargin - btnMargin * 4 )/4;
    CGFloat btnHeight       = btnWidth;
    
    CGFloat btnHeightWithMargin = btnMargin + btnHeight;
    CGFloat btnWidthWithMargin  = btnMargin + btnWidth;
    
    CGFloat topMargin       = parentHeight - 4 * btnHeightWithMargin - bottomMargin;
    
    CGFloat left;
    CGFloat top;
    
    /* Buton 1 ~ 9 */
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
//            btn.tag = (row - 1) * 3 + col;
            btn.tag = (3 - row) * 3 + col;
            [btn setTitle:[NSString stringWithFormat:@"%d", (int)btn.tag] forState:UIControlStateNormal];
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
    [btn11 addTarget:self action:@selector(submitButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
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
    [btn12 addTarget:self action:@selector(returnButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
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
    [btn13 addTarget:self action:@selector(clearOneButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
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
    [btn14 addTarget:self action:@selector(changesButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:btn14];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updatePayment {
    _payment.text = [Helper setToCurrency:currentInput];
}

- (void)updateChanges {
    _change.text  = [Helper setToCurrency:currentChanges];
}
@end
