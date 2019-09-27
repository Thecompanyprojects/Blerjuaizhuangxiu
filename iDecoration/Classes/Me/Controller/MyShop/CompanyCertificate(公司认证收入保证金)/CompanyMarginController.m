//
//  CompanyMarginController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CompanyMarginController.h"
#import "CompanyMarginNextController.h"
#import "ZCHPublicWebViewController.h"
#import "LockedMarginViewController.h"
#import "CompanywithdrawalVC.h"


@interface CompanyMarginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewTopCon;
// 已充值保证金
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
// 锁定保证金
@property (weak, nonatomic) IBOutlet UILabel *moneyLabelTwo;

@property (weak, nonatomic) IBOutlet UIButton *payMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *makeMoneyBtn;

@property (nonatomic,copy) NSString *token;


@end

@implementation CompanyMarginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交保证金";
    self.topImageViewTopCon.constant = self.navigationController.navigationBar.bottom + 5;
    self.payMoneyBtn.layer.cornerRadius = 4;
    self.payMoneyBtn.layer.masksToBounds = YES;
    self.makeMoneyBtn.layer.cornerRadius = 4;
    self.makeMoneyBtn.layer.masksToBounds = YES;
    self.makeMoneyBtn.layer.borderWidth = 1;
    self.makeMoneyBtn.layer.borderColor = kCustomColor(221, 221, 221).CGColor;
    [self getCompanyData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)payMoneyAction:(id)sender {
    CompanyMarginNextController *nextVC = [[CompanyMarginNextController alloc] initWithNibName:@"CompanyMarginNextController" bundle:nil];
    nextVC.marginType = MarginTypePayment;
    nextVC.companyId = self.companyId;
    nextVC.backSuccessBlock = ^{
        [self getCompanyData];
    };
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (IBAction)makeMoneyAction:(id)sender {
    CompanywithdrawalVC *vc = [CompanywithdrawalVC new];
    vc.companyId = self.companyId;
    vc.type = @"0";
    vc.token = self.token;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)explainAction:(id)sender {
    ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
    managerMustReadVC.titleStr = @"保证金说明";
    managerMustReadVC.webUrl = @"resources/html/baozhengjin.html";
    [self.navigationController pushViewController:managerMustReadVC animated:YES];
}

- (IBAction)lockedMarginAction:(id)sender {
    LockedMarginViewController *vc = [[LockedMarginViewController alloc] initWithNibName:@"LockedMarginViewController" bundle:nil];
    vc.companyId = self.companyId;
    vc.money = self.moneyLabelTwo.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getCompanyData {
    self.moneyLabel.text = @"￥0.00";
    self.moneyLabelTwo.text = @"￥0.00";
    
    NSString *defaultAPI = [BASEURL stringByAppendingString:@"company/companyMoney.do"];
    NSDictionary *paraDic = @{@"companyId": self.companyId};
    [NetManager afPostRequest:defaultAPI parms:paraDic finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1000) {
            NSDictionary *dict = responseObj[@"data"][@"companyMoney"];
            // 总金额 = 冻结的金额和非冻结的金额
            NSString *companyActivityBond = dict[@"companyActivityBond"];
            // 冻结的金额
            NSString *frozenActivityMoney = dict[@"frozenActivityMoney"];
            
//            // 已提现的金额 定金收入的
//            NSInteger  withdrawalsNo = [dict[@"withdrawalsNo"] integerValue];
//            // 可提现的定金收入
//            NSInteger  withdrawalsYes = [dict[@"withdrawalsYes"] integerValue];
            self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",companyActivityBond];
            self.moneyLabelTwo.text = [NSString stringWithFormat:@"￥%@",frozenActivityMoney];
            self.token = [responseObj objectForKey:@"token"];
        }
        if (code == 1004) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您的公司未认证或认证已过期，请前去认证"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
