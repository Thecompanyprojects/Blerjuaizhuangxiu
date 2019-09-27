//
//  CertificateInformationViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CertificateInformationViewController.h"
#import "CompanyCertificationController.h"

@interface CertificateInformationViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewTopCon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 2017年10月30日至2018年10月30日
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *registCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *legalPersonLabel;

@end

@implementation CertificateInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证信息";
    self.topBgViewTopCon.constant= kNaviBottom + 8;
    UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"重新认证" target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSString *adoptTime = [NSDate yearMoneyDayWithChineseFromTimeInterval:self.model.adoptTime/1000.0];
    NSString *overTime = [NSDate yearMoneyDayWithChineseFromTimeInterval:self.model.overdueDate/1000.0];
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@", adoptTime, overTime];
    self.companyNameLabel.text = self.model.companyName;
    self.registCodeLabel.text = self.model.regCode;
    self.legalPersonLabel.text = self.model.personName;
    
    switch (self.model.status) {
        case CertificateStatusUnPay: // 未支付
            break;
        case CertificateStatusUnderway: // 认证中
        {
            self.timeView.hidden = YES;
            self.toTimeViewCon.constant = 0;
        }
            break;
        case CertificateStatusFailure: // 认证失败
            break;
        case CertificateStatusTimeOut: // 认证过期
            break;
            
        case CertificateStatusSuccess: // 认证通过
            break;
        case CertificateStatusUnknown: // 未认证过
            break;
        default:
            break;
    }
}

- (void)rightAction {
    // 重新认证
    CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.companyId;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
