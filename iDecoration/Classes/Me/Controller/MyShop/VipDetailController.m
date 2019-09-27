//
//  VipDetailController.m
//  iDecoration
//
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "VipDetailController.h"
#import "AppDelegate.h"
#import "ZCHPublicWebViewController.h"

@interface VipDetailController ()

@property (weak, nonatomic) IBOutlet UIButton *aLiPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wXPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *yearVIPMemberBtn;
@property (weak, nonatomic) IBOutlet UILabel *yearPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouldPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouldPriceLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *packageBtn;

@end

@implementation VipDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self creatUI];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayResult:) name:@"AlipayResult" object:nil];
    
    if (IPhone5 || IPhone4) {
        self.shouldPriceLabel.text = @"= 1200";
        self.shouldPriceLabelWidth.constant = 50;
    }
}

- (void)creatUI {
    
    self.title = @"企业网会员";
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - 44 * 5 - self.navigationController.navigationBar.bottom - 40)];
    bottomView.backgroundColor = White_Color;
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, bottomView.top + 30, BLEJWidth - 40, 44)];
    payBtn.backgroundColor = kMainThemeColor;
    [payBtn setTitle:@"开通会员" forState:UIControlStateNormal];
    payBtn.layer.cornerRadius = 5;
    payBtn.layer.masksToBounds = YES;
    [payBtn addTarget:self action:@selector(didClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payBtn];
    
    UIButton *protocolBtn = [[UIButton alloc] initWithFrame:CGRectMake(payBtn.left, payBtn.bottom + 5, 80, 30)];
    [protocolBtn setImage:[UIImage imageNamed:@"protocol"] forState:UIControlStateNormal];
    [protocolBtn setTitle:@"支付协议" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    protocolBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [protocolBtn addTarget:self action:@selector(didClickProtocolBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:protocolBtn];
    
    NSString *str;
    str = @"        开通此会员可以快速创建生成企业网站，网站内90％的信息来自云管理系统，内容智能抓取免维护。  ";
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(payBtn.width, MAXFLOAT) withFont:[UIFont systemFontOfSize:14]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(payBtn.left, protocolBtn.bottom + 20, payBtn.width, size.height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = str;
    [bottomView addSubview:label];
    
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomView.height - 40, BLEJWidth, 30)];
    companyLabel.text = @"北京比邻而居科技有限公司提供技术支持";
    companyLabel.textColor = [UIColor darkGrayColor];
    [companyLabel setFont:[UIFont systemFontOfSize:10.0]];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.backgroundColor = Clear_Color;
    
    [bottomView addSubview:companyLabel];
    
    self.tableView.tableFooterView = bottomView;
}

- (void)getData {
    
    NSString *apiURL = [BASEURL stringByAppendingString:@"paybill/getPrice.do"];
    [NetManager afGetRequest:apiURL parms:nil finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            self.yearPriceLabel.text = [NSString stringWithFormat:@"%@元", responseObj[@"prices"][1]];
            self.realPriceLabel.text = [NSString stringWithFormat:@"优惠套餐%@元", responseObj[@"prices"][7]];
            self.shouldPriceLabel.text = [NSString stringWithFormat:@"= %@元", responseObj[@"prices"][8]];
            
        } else {
            
            self.yearPriceLabel.text = @"400元";
        }
        
    } failed:^(NSString *errorMsg) {
        
        self.yearPriceLabel.text = @"400元";
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            // 跳转非会员简介
//            ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
//            VC.titleStr = @"非会员简介";
//            VC.webUrl = @"resources/html/feihuiyuanjianjie.html";
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//        if (indexPath.row == 1) {
//            // 跳转会员简介
//            ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
//            VC.titleStr = @"会员简介";
//            VC.webUrl = @"resources/html/huiyuanjieshao.html";
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 4) {
//        return BLEJHeight - self.navigationController.navigationBar.bottom - 44 * 7 - 10 * 6;
//    }
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

- (void)didClickConfirmBtn:(UIButton *)sender {
    
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    if (self.wXPayBtn.selected == YES) {
        
        if (self.yearVIPMemberBtn.selected == YES) {// 企业年度会员
            NSString *param = [NSString stringWithFormat:@"companyVip,%@,%d,%@", self.companyId, 1, agencyId];
            
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
        } else {// 套餐
            
            NSString *param = [NSString stringWithFormat:@"companyPacVip,%@,%d,%@", self.companyId, 3, agencyId];
            
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
        
        
    } else {
        
        if (self.yearVIPMemberBtn.selected == YES) {// 企业年度会员
            
            NSString *defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/vip.do"];
            NSDictionary *paramDic = @{@"vipType" : @"companyVip",
                                       @"type" : @(1),
                                       @"relId" : self.companyId,
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
        } else {// 套餐
            
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

#pragma mark - 微信支付回调结果
- (void)WXPayResult:(NSNotification *)noc {
    
    // 0: 支付成功  -1: 支付失败  -2: 支付取消  (其他的都是失败)
    if ([noc.object integerValue] == 0) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        self.successBlock();
        
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
        self.successBlock();
    } else if ([noc.object[@"resultStatus"] integerValue] == 6001) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付取消"];
    } else {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付失败"];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
