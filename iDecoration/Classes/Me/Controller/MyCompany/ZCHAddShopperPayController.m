//
//  ZCHAddShopperPayController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHAddShopperPayController.h"
#import "AppDelegate.h"
#import "ZCHPublicWebViewController.h"

@interface ZCHAddShopperPayController ()

@property (weak, nonatomic) IBOutlet UIButton *aLiPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wXPayBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ZCHAddShopperPayController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"商家入驻开通";
    [self setUpUI];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayResult:) name:@"AlipayResult" object:nil];
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)setUpUI {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - 44 * 4 - 64)];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
    topView.backgroundColor = kBackgroundColor;
    [bottomView addSubview:topView];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, topView.bottom + 40, BLEJWidth - 40, 44)];
    payBtn.backgroundColor = kMainThemeColor;
    [payBtn setTitle:@"确定支付" forState:UIControlStateNormal];
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
    
//    UIImageView *bottomLogo = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 90, bottomView.bottom - 60, 180, 37)];
//    bottomLogo.image = [UIImage imageNamed:@"bottomLogo"];
//    [bottomView addSubview:bottomLogo];
    
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
            
            self.priceLabel.text = [NSString stringWithFormat:@"%@元/年", responseObj[@"prices"][2]];
            
        } else {
            
            self.priceLabel.text = @"400元/年";
            
        }
        
    } failed:^(NSString *errorMsg) {
        
        self.priceLabel.text = @"400元/年";
    }];
    
    
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
        
        NSString *param = [NSString stringWithFormat:@"addMerchant,%@,%@,%@,%@", self.companyId, self.merchantId,self.isHaveAdd, agencyId];
        
        NSString *defaultApi = [BASEURL stringByAppendingString:@"wxPay/pre.do"];
        NSDictionary *paramDic = @{@"attach":param
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"], @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"], @"noncestr" : responseObj[@"noncestr"], @"timestamp" : @([responseObj[@"timestamp"] intValue]), @"sign" : responseObj[@"sign"]};
                
                [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
            }
            
        } failed:^(NSString *errorMsg) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
        }];
    } else {
        
        NSString *defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/addMerchant.do"];
        NSDictionary *paramDic = @{@"merchantId" : self.merchantId,
                                   @"companyId" : self.companyId,
                                   @"type" : self.isHaveAdd,
                                   @"agencyId" : agencyId
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
            }
            
            NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
        }];
        
    }
}

#pragma mark - 微信支付回调结果
- (void)WXPayResult:(NSNotification *)noc {
    
    // 0: 支付成功  -1: 支付失败  -2: 支付取消  (其他的都是失败)
    if ([noc.object integerValue] == 0) {
        
        if (self.isHaveAdd) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费成功"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加成功"];
        }
        
        
        if (self.isAddJoin) {
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        } else {
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
        }
    } else {
        
        if (self.isHaveAdd) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费失败"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加失败"];
        }
    }
}

#pragma mark - 支付宝支付回调结果
- (void)AlipayResult:(NSNotification *)noc {
    
    if ([noc.object[@"resultStatus"] integerValue] == 9000 ) {
        
        if (self.isHaveAdd) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费成功"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加成功"];
        }
        
        
        if (self.isAddJoin) {
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        } else {
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
        }
    } else {
        
        if (self.isHaveAdd) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费失败"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加失败"];
        }
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
