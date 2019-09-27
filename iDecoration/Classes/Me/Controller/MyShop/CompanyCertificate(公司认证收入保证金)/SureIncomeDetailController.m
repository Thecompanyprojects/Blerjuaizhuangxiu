//
//  SureIncomeDetailController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SureIncomeDetailController.h"

@interface SureIncomeDetailController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewTopCon;
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 活动时间
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;

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

@implementation SureIncomeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.topBgViewTopCon.constant = kNaviBottom;
    
    if (self.companyIncomeModel) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.companyIncomeModel.coverMap]];
        self.titleLabel.text = self.companyIncomeModel.costName;
        
        NSString *timeStr = [NSDate yearMoneyDayAndHourMinuteFromTimeInterval:self.companyIncomeModel.startTime.doubleValue/1000.0];
        self.activityTimeLabel.text = [NSString stringWithFormat:@"时间:%@开始", timeStr];
        self.payStyleLabel.text = [self.companyIncomeModel.payWay isEqualToString:@"1"] ? @"微信": @"支付宝";
        NSString *payTimeStr = [NSDate yearMoneyDayAndHourMinuteFromTimeInterval:self.companyIncomeModel.payDate.doubleValue/1000.0];
        self.payTimeLabel.text = payTimeStr;
        self.payMonayLabel.text = [NSString stringWithFormat:@"￥%@", self.companyIncomeModel.money];
        self.nameLabel.text = self.companyIncomeModel.trueName;
        self.orderNumber.text = self.companyIncomeModel.orderId;
        self.phoneNumber.text = self.companyIncomeModel.userPhone;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
