//
//  CertificationPayController.m
//  iDecoration
//
//  Created by zuxi li on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CertificationPayController.h"
#import "AppDelegate.h"

@interface CertificationPayController ()
@property (nonatomic, strong) UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;

@end

@implementation CertificationPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审核费用支付";
    [self buildBottomView];
    // 以后次控制器中的tableView是 _myTableView  self.view 是一个单独的view
    self.aliPayBtn.selected = YES;
    
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

// 支付
- (void)payAction {
    if (!self.aliPayBtn.selected && !self.weixinPayBtn.selected) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择支付方式"];
        return ;
    }
    UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
    if (self.weixinPayBtn.selected == YES) {
        // 微信支付
            NSString *param = [NSString stringWithFormat:@"authentication,%@,%ld", self.companyId, model.agencyId];

            NSString *defaultApi = [BASEURL stringByAppendingString:@"wxPay/pre.do"];
            NSDictionary *paramDic = @{@"attach":param
                                       };
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {

                if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {

                    NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"], @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"], @"noncestr" : responseObj[@"noncestr"], @"timestamp" : @([responseObj[@"timestamp"] intValue]), @"sign" : responseObj[@"sign"]};

                    [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
                }
            } failed:^(NSString *errorMsg) {

                [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
            }];
        }
        
        if (self.aliPayBtn.selected) {
            // 支付宝支付
            NSString *defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/authencation.do"];
            NSDictionary *paramDic = @{@"companyId" : @(self.companyId.integerValue),
                                       @"agencysId" : @(model.agencyId)
                                       };
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                
                if ([responseObj[@"code"]integerValue] == 1000) {
                    
                    NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
                } else {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取信息失败， 请稍后再试！"];
                }
                
            } failed:^(NSString *errorMsg) {
                
                [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
            }];
        }
    
}

#pragma mark - 微信支付回调结果
- (void)WXPayResult:(NSNotification *)noc {
    
    // 0: 支付成功  -1: 支付失败  -2: 支付取消  (其他的都是失败)
    if ([noc.object integerValue] == 0) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        });
//        if (self.successBlock) {
//            self.successBlock();
//        }
        [self uploadData];
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
        [self uploadData];
    } else if ([noc.object[@"resultStatus"] integerValue] == 6001) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付取消"];
    } else {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付失败"];
    }
}

- (void)buildBottomView {
    UITableView *tableView = (UITableView *)self.view;
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    tableView.frame = tableView.bounds;
    self.view = containerView;
    [containerView addSubview:tableView];
    self.myTableView = tableView;
    UIButton *buttonPay = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:buttonPay];
    buttonPay.frame = CGRectMake(20, kSCREEN_HEIGHT - 45 - 20, kSCREEN_WIDTH - 40, 45);
    [buttonPay setBackgroundColor:basicColor forState:(UIControlStateNormal)];
    buttonPay.layer.cornerRadius = 6.0f;
    buttonPay.layer.masksToBounds = true;
    [buttonPay setTitle:@"马上支付" forState:(UIControlStateNormal)];
    [buttonPay addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)uploadData {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAuthentication/authentication.do"];
    [NetManager afPostRequest:defaultApi parms:self.dicData finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:responseObj[@"msg"]];
        if (code != 1000) {
            return ;
        }
        if (self.successBlock) {
            self.successBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {

    }];
}
@end
