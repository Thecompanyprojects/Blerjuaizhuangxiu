//
//  MyOrderDetailViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "MyOrderDetailViewController.h"

@interface MyOrderDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewTopCon;
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 活动时间
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
// 确认报名  已到账收入和锁定保证金列表跳转来的详情 没有 确认报名按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;
// 支付时间
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
// 报名费用 ￥88.00
@property (weak, nonatomic) IBOutlet UILabel *payMonayLabel;
// 报名人
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
// 电话
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;


@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.topBgViewTopCon.constant = kNaviBottom;
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    if (self.myOrderModel) {
        self.sureBtn.hidden = NO;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.myOrderModel.coverMap]];
        self.titleLabel.text = self.myOrderModel.designTitle;
        
        NSString *timeStr = [NSDate yearMoneyDayAndHourMinuteFromTimeInterval:self.myOrderModel.startTime.doubleValue/1000.0];
        self.activityTimeLabel.text = [NSString stringWithFormat:@"时间:%@开始", timeStr];
        self.payStyleLabel.text = [self.myOrderModel.payWay isEqualToString:@"1"] ? @"微信": @"支付宝";
        NSString *payTimeStr = [NSDate yearMoneyDayAndHourMinuteFromTimeInterval:self.myOrderModel.payDate.doubleValue/1000.0];
        self.payTimeLabel.text = payTimeStr;
        self.payMonayLabel.text = [NSString stringWithFormat:@"￥%@", self.myOrderModel.money];
        self.nameLabel.text = self.myOrderModel.userName;
        self.orderNumber.text = self.myOrderModel.orderId;
        self.phoneNumber.text = self.myOrderModel.userPhone;
        
        // （0：未支付，1：待确认，2：已确认）
        if (self.myOrderModel.status.integerValue == 1) {
            self.sureBtn.enabled = YES;
        }
        if (self.myOrderModel.status.integerValue == 2) {
            self.sureBtn.enabled = NO;
            self.sureBtn.hidden = YES;
        }
        if (self.myOrderModel.status.integerValue == 0) {
            self.sureBtn.hidden = YES;
        }
        
    }
}


- (IBAction)sureAction:(id)sender {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signUp/qrSignUp.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.myOrderModel.signUpId forKeyedSubscript:@"signUpId"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"报名成功"];
        }
        if (code == 1001) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"参数错误"];
        }
        if (code == 1002) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该订单未支付或已经确认过"];
        }
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
