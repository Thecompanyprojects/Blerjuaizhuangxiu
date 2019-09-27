//
//  ActivityPayViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ActivityPayViewController.h"
#import "AppDelegate.h"

@interface ActivityPayViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopCon;

@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@end

@implementation ActivityPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.bgViewTopCon.constant = self.navigationController.navigationBar.bottom;
    self.aliPayBtn.selected = YES;
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayResult:) name:@"AlipayResult" object:nil];
}

- (IBAction)weixinPayBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.aliPayBtn.selected = NO;
    }
}
- (IBAction)aliPayBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.weixinPayBtn.selected = NO;
}

- (IBAction)payAction:(id)sender {
    
    if (!self.aliPayBtn.selected && !self.weixinPayBtn.selected) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择支付方式"];
        return ;
    }
    UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    NSInteger payType = 0;
    if (self.weixinPayBtn.selected == YES) {
        payType = 1;
    }

    
    NSDictionary *paramDic = @{
                               @"activityId": self.activityID,
                               @"payType": @(payType),
                               @"signUpId": @(self.signUpId),
                               @"agencysId": @(model.agencyId)
                               };
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signUp/signUpPayment.do"];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if (responseObj && [responseObj[@"code"]integerValue] == 1003){
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该活动不需要支付费用"];
            return ;
        }
        
        if (responseObj && [responseObj[@"code"]integerValue] == 1000) {
            if (self.weixinPayBtn.selected) {
                // 微信支付
                NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"], @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"], @"noncestr" : responseObj[@"noncestr"], @"timestamp" : @([responseObj[@"timestamp"] intValue]), @"sign" : responseObj[@"sign"]};
                
                [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
            }
            
            if (self.aliPayBtn.selected) {
                NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
            }
            
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取信息失败， 请稍后再试！"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
}


#pragma mark - 微信支付回调结果
- (void)WXPayResult:(NSNotification *)noc {
    
    // 0: 支付成功  -1: 支付失败  -2: 支付取消  (其他的都是失败)
    if ([noc.object integerValue] == 0) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
        });
        if (self.successBlock) {
            self.successBlock();
        }
        
    } else if ([noc.object integerValue] == -2) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付取消"];
    } else {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付失败"];
    }
}

#pragma mark - 支付宝支付回调结果
- (void)AlipayResult:(NSNotification *)noc {
    
    if ([noc.object[@"resultStatus"] integerValue] == 9000) {
        
                [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
        if (self.successBlock) {
            self.successBlock();
        }
    } else if ([noc.object[@"resultStatus"] integerValue] == 6001) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付取消"];
    } else {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付失败"];
    }
}


@end
