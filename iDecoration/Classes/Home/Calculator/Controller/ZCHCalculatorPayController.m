//
//  ZCHCalculatorPayController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCalculatorPayController.h"
#import "AppDelegate.h"
#import "ZCHPublicWebViewController.h"

@interface ZCHCalculatorPayController ()

@property (weak, nonatomic) IBOutlet UIButton *aLiPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wXPayBtn;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *yearVIPMemberBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouldPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouldPriceLaelWidth;

@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *packageBtn;

@end

@implementation ZCHCalculatorPayController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.isNotCompany) {
        
        self.title = @"企业号码通";
    } else {
        
        self.title = @"员工号码通";
    }
    
    if (IPhone5 || IPhone4) {
        self.shouldPriceLabel.text = @"= 1200";
        self.shouldPriceLaelWidth.constant = 50;
    }
    
    [self setUpUI];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayResult:) name:@"AlipayResult" object:nil];
}

- (void)setUpUI {
    
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - 44 * 5 - self.navigationController.navigationBar.bottom - 40)];
    bottomView.backgroundColor = White_Color;
    
    if (self.isNotCompany) {
        
        self.yearVIPMemberBtn.selected = YES;
        self.packageBtn.selected = NO;
        bottomView.frame = CGRectMake(0, 0, BLEJWidth, BLEJHeight - 44 * 4 - self.navigationController.navigationBar.bottom - 30);
    }
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
//    topView.backgroundColor = kBackgroundColor;
//    
//    [bottomView addSubview:topView];
    
//    if ([self.type isEqualToString:@"0"]) {
//        
//        UIButton *tryBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, topView.bottom + 20, BLEJWidth - 40, 44)];
//        tryBtn.backgroundColor = kColorRGB(0xffc81e);
//        [tryBtn setTitle:@"免费体验1天" forState:UIControlStateNormal];
//        tryBtn.layer.cornerRadius = 5;
//        tryBtn.layer.masksToBounds = YES;
//        [tryBtn addTarget:self action:@selector(didClickTryBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:tryBtn];
//        
//        UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, topView.bottom + 84, BLEJWidth - 40, 44)];
//        payBtn.backgroundColor = kMainThemeColor;
//        [payBtn setTitle:@"确定支付" forState:UIControlStateNormal];
//        payBtn.layer.cornerRadius = 5;
//        payBtn.layer.masksToBounds = YES;
//        [payBtn addTarget:self action:@selector(didClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
//        self.payBtn = payBtn;
//        [bottomView addSubview:payBtn];
//    } else {
    
        UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, bottomView.top + 30, BLEJWidth - 40, 44)];
        payBtn.backgroundColor = kMainThemeColor;
        [payBtn setTitle:@"确定支付" forState:UIControlStateNormal];
        payBtn.layer.cornerRadius = 5;
        payBtn.layer.masksToBounds = YES;
        [payBtn addTarget:self action:@selector(didClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.payBtn = payBtn;
        [bottomView addSubview:payBtn];
    
    UIButton *protocolBtn = [[UIButton alloc] initWithFrame:CGRectMake(payBtn.left, payBtn.bottom + 5, 80, 30)];
    [protocolBtn setImage:[UIImage imageNamed:@"protocol"] forState:UIControlStateNormal];
    [protocolBtn setTitle:@"支付协议" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    protocolBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [protocolBtn addTarget:self action:@selector(didClickProtocolBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:protocolBtn];
    
//    }
//    
//    UIImageView *bottomLogo = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 90, bottomView.bottom - 80, 180, 37)];
//    bottomLogo.image = [UIImage imageNamed:@"bottomLogo"];
//    [bottomView addSubview:bottomLogo];
    
    // @"会员特权：会员开通后，每个员工都可在公司架构下生成独立的计算器二维码，每个二维码的持有人都可以独立接收客户信息，总经理/经理可接收到架构内所有员工的客户信息以防止跑单。"
    NSString *str;
    // 此业务是公司用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按300元/年计算，此费用由短信提供商收取。
    if (!self.isNotCompany) {
        
        str = @"        此业务是公司用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按400元/年计算，此费用由短信提供商收取。  ";
    } else {
        
        str = @"        此业务是员工用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按9.9元/年计算，此费用由短信提供商收取。  ";
    }
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(self.payBtn.width, MAXFLOAT) withFont:[UIFont systemFontOfSize:14]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.payBtn.left, protocolBtn.bottom + 20, self.payBtn.width, size.height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    self.titleLabel = label;
    label.text = str;
    [bottomView addSubview:label];
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomView.height - 40, BLEJWidth, 30)];
    companyLabel.text = @"北京比邻而居科技有限公司提供技术支持";
    companyLabel.textColor = [UIColor darkGrayColor];
    [companyLabel setFont:[UIFont systemFontOfSize:10.0]];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.backgroundColor = Clear_Color;
    
    [bottomView addSubview:companyLabel];
//    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.height.equalTo(@30);
//        make.width.equalTo(@200);
//        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
//    }];
    
    self.tableView.tableFooterView = bottomView;
}

- (void)getData {
    
    NSString *apiURL = [BASEURL stringByAppendingString:@"paybill/getPrice.do"];
    [NetManager afGetRequest:apiURL parms:nil finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            if (!self.isNotCompany) {
                
                self.priceLabel.text = [NSString stringWithFormat:@"%@元", responseObj[@"prices"][3]];
                self.realPriceLabel.text = [NSString stringWithFormat:@"优惠套餐%@元", responseObj[@"prices"][7]];
                self.shouldPriceLabel.text = [NSString stringWithFormat:@"= %@元", responseObj[@"prices"][8]];
                self.titleLabel.text = [NSString stringWithFormat:@"        此业务是公司用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按%@元/年计算，此费用由短信提供商收取。  ", responseObj[@"prices"][3]];
            } else {// 业务员会员
                
                self.priceLabel.text = [NSString stringWithFormat:@"%@元", responseObj[@"prices"][6]];
                self.titleLabel.text = [NSString stringWithFormat:@"        此业务是员工用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按%@元/年计算，此费用由短信提供商收取。  ", responseObj[@"prices"][6]];
            }
            
        } else {
            
            if (!self.isNotCompany) {
                
                self.priceLabel.text = @"400元";
                self.titleLabel.text = @"        此业务是公司用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按400元/年计算，此费用由短信提供商收取。  ";
            } else {// 业务员会员
                
                self.priceLabel.text = @"9.9元";
                self.titleLabel.text = @"        此业务是员工用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按9.9元/年计算，此费用由短信提供商收取。  ";
            }
        }
    } failed:^(NSString *errorMsg) {
        
        if (!self.isNotCompany) {
            
            self.priceLabel.text = @"400元";
            self.titleLabel.text = @"        此业务是公司用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按400元/年计算，此费用由短信提供商收取。  ";
        } else {// 业务员会员
            
            self.priceLabel.text = @"9.9元";
            self.titleLabel.text = @"        此业务是员工用来收集用户手机信息功能（计算器、活动报名、促销验证）的短信费用，短信按9.9元/年计算，此费用由短信提供商收取。  ";
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.isNotCompany && section == 1) {
        
        return 0.001;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isNotCompany && indexPath.section == 1) {
        
        return 0.001;
    }
    return 44;
}


- (IBAction)didClickVIPMemberBtn:(UIButton *)sender {
    
    if (sender == self.yearVIPMemberBtn) {
        
        self.yearVIPMemberBtn.selected = YES;
        self.packageBtn.selected = NO;
    } else {
        
        self.yearVIPMemberBtn.selected = NO;
        self.packageBtn.selected = YES;
    }
}

#pragma mark - 支付按钮的点击事件
- (IBAction)didClickPayBtn:(UIButton *)sender {
    
    if (sender == self.aLiPayBtn) {
        
        self.aLiPayBtn.selected = YES;
        self.wXPayBtn.selected = NO;
    } else {
        
        self.aLiPayBtn.selected = NO;
        self.wXPayBtn.selected = YES;
    }
}

#pragma mark - 支付协议的点击事件
- (void)didClickProtocolBtn:(UIButton *)btn {
    
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"支付协议";
    VC.webUrl = @"resources/html/fufeixieyi.html";
    [self.navigationController pushViewController:VC animated:YES];
}

//#pragma mark - 试用按钮的点击事件
//- (void)didClickTryBtn:(UIButton *)btn {
//    
//    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
//    
//    NSString *defaultApi = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"calvip/%@-%@.do", self.companyId, agencyId]];
//    NSDate *date = [NSDate date];
//    NSString *timeStr = [NSString stringWithFormat:@"%ld000", (long)[date timeIntervalSince1970]];
//    NSDictionary *paramDic = @{
//                               @"time" : timeStr
//                               };
//    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
//        
//        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
//            
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"试用成功"];
//        } else if (responseObj && [responseObj[@"code"] integerValue] == 1002) {
//            
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已经开通过会员或体验过"];
//        } else {
//            
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"试用失败"];
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//        if (self.refreshBlock) {
//            
//            self.refreshBlock();
//        }
//    } failed:^(NSString *errorMsg) {
//        
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
//    }];
//}

- (void)didClickConfirmBtn:(UIButton *)sender {
    
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请重新登录"];
        return;
    }
    
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    if (self.wXPayBtn.selected == YES) {
        
        NSString *param;
        
        if (self.isNotCompany) {// 业务员会员
            
            if (self.beOpenedId) {// 不是给登录人开通会员的
                param = [NSString stringWithFormat:@"companySalsemanVip,%@,%@,%@", self.companyId, @"1", self.beOpenedId];
            } else {
                param = [NSString stringWithFormat:@"companySalsemanVip,%@,%@,%@", self.companyId, @"1", agencyId];
            }
            NSString *defaultApi = [BASEURL stringByAppendingString:@"wxPay/pre.do"];
            NSDictionary *paramDic = @{
                                       @"attach" : param
                                       };
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                
                if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
                    
                    NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"], @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"], @"noncestr" : responseObj[@"noncestr"], @"timestamp" : @([responseObj[@"timestamp"] intValue]), @"sign" : responseObj[@"sign"]};
                    
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
                }
                
            } failed:^(NSString *errorMsg) {
                
                [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
            }];
        } else {
            
            if (self.yearVIPMemberBtn.selected == YES) {// 号码通年度会员
                
                param = [NSString stringWithFormat:@"calcultorVip,%@,%@,%@", self.companyId, self.type, agencyId];
                NSString *defaultApi = [BASEURL stringByAppendingString:@"wxPay/pre.do"];
                NSDictionary *paramDic = @{
                                           @"attach" : param
                                           };
                [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                    
                    if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
                        
                        NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"], @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"], @"noncestr" : responseObj[@"noncestr"], @"timestamp" : @([responseObj[@"timestamp"] intValue]), @"sign" : responseObj[@"sign"]};
                        
                        [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
                    }
                    
                } failed:^(NSString *errorMsg) {
                    
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
                }];
            } else {
                
                param = [NSString stringWithFormat:@"companyPacVip,%@,%d,%@", self.companyId, 3, agencyId];
                
                NSString *defaultApi = [BASEURL stringByAppendingString:@"wxPay/pre.do"];
                NSDictionary *paramDic = @{@"attach" : param
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
            
        }
        
    } else {
        
        if (self.isNotCompany) {// 业务员会员
            
            NSString *defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/salsemanVip.do"];
//            NSDictionary *paramDic = @{
//                                       @"companyId" : self.companyId,
//                                       @"agencyId" : agencyId
//                                       };
            
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setObject:self.companyId forKey:@"companyId"];
            if (self.beOpenedId) {
                [paramDic setObject:self.beOpenedId forKey:@"agencyId"];
            } else {
                [paramDic setObject:agencyId forKey:@"agencyId"];
            }
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                
                if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
                    
                    NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
                }
                
            } failed:^(NSString *errorMsg) {
                
                [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
            }];
        } else {
            
            if (self.yearVIPMemberBtn.selected == YES) {// 号码通年度会员
                
                NSString *defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/calcultorVip.do"];
                NSDictionary *paramDic = @{
                                           @"companyId" : self.companyId,
                                           @"type" : self.type,
                                           @"agencyId" : agencyId
                                           };
                [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                    
                    if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
                        
                        NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                        [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
                    }
                    
                } failed:^(NSString *errorMsg) {
                    
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
                }];
            } else {
                
                NSString *defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/packageVip.do"];
                NSDictionary *paramDic = @{@"companyId" : self.companyId,
                                           @"agencyId" : agencyId
                                           };
                [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                    
                    if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                        
                        NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                        [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
                    }
                    
                } failed:^(NSString *errorMsg) {
                    
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
                }];
            }
        }
    }
}

#pragma mark - 微信支付回调结果
- (void)WXPayResult:(NSNotification *)noc {
    
    // 0: 支付成功  -1: 支付失败  -2: 支付取消  (其他的都是失败)
    if ([noc.object integerValue] == 0) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"支付成功"];
//        if ([self.type isEqualToString:@"0"]) {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"开通成功"];
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费成功"];
//        }
        if (self.refreshBlock) {
            
            self.refreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([noc.object integerValue] == -2) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"支付取消"];
    } else {
        
//        if ([self.type isEqualToString:@"0"]) {
        
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"支付失败"];
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费失败"];
//        }
    }
}

#pragma mark - 支付宝支付回调结果
- (void)AlipayResult:(NSNotification *)noc {
    
    if ([noc.object[@"resultStatus"] integerValue] == 9000 ) {
        
//        if ([self.type isEqualToString:@"0"]) {
        
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"支付成功"];
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费成功"];
//        }
        if (self.refreshBlock) {
            
            self.refreshBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([noc.object[@"resultStatus"] integerValue] == 6001) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"支付取消"];
    } else {
        
//        if ([self.type isEqualToString:@"0"]) {
        
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"支付失败"];
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费失败"];
//        }
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
