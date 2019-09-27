//
//  OrderToInformViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/8/28.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "OrderToInformViewController.h"

@interface OrderToInformViewController ()

@end

@implementation OrderToInformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model.money = @"100元/年";
    self.model.discountPackageDetail = @"订单通知";
    [self.tableView reloadData];
    self.title = @"提醒短信";
}

- (void)pay {
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    __block NSInteger index = 0;
    [self.model.arrayPay enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = obj;
        if ([dic[@"typeSelected"] isEqualToString:@"1"]) {
            index = idx;
        }
    }];
    __block BOOL isAliPay = true;
    NSString *URL = [BASEURL stringByAppendingString:@"company/smsNotification.do"];
    NSMutableDictionary *parameters = @{}.mutableCopy;
    parameters[@"companyId"] = self.companyId;
    parameters[@"agencyId"] = agencyId;
    switch (index) {
        case 0: {//支付宝
            parameters[@"payType"] = @(0);
            isAliPay = true;
        }
            break;
        case 1: {//微信
            parameters[@"payType"] = @(1);
            isAliPay = false;
        }
            break;
        default:
            break;
    }
    [NetManager afPostRequest:URL parms:parameters finished:^(id responseObj) {
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            if (isAliPay) {
                NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
            }else{
                NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"], @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"], @"noncestr" : responseObj[@"noncestr"], @"timestamp" : @([responseObj[@"timestamp"] intValue]), @"sign" : responseObj[@"sign"]};
                [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
            }
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

@end
