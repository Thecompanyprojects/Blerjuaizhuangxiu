//
//  CertificateSuccessNewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CertificateSuccessNewController.h"
#import "CertificateInformationViewController.h"
#import "CertificateStatusController.h"
#import "CompanyCertificationController.h"
#import "CertificationPayController.h"

@interface CertificateSuccessNewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewTopCon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 有效期：2017-12-30 14:00 至 2018-12-30 14:00 

@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@end

@implementation CertificateSuccessNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业认证";
    self.topBgViewTopCon.constant = kNaviBottom;
    self.topBtn.layer.cornerRadius = 5;
    self.topBtn.layer.borderWidth = 1;
    self.topBtn.layer.borderColor = kCustomColor(255, 154, 43).CGColor;
    self.topBtn.layer.masksToBounds = YES;
    UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"认证信息" target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSString *adoptTime = [NSDate yearMoneyDayAndHourMinuteFromTimeInterval:self.model.adoptTime/1000.0];
    NSString *overTime = [NSDate yearMoneyDayAndHourMinuteFromTimeInterval:self.model.overdueDate/1000.0];
    self.timeLabel.text = [NSString stringWithFormat:@"有效期：%@至%@", adoptTime, overTime];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
    self.timeLabel.hidden = YES;
    switch (self.model.status) {
        case CertificateStatusUnPay: // 未支付
        {
            [self.topBtn setTitle:@"未支付" forState:UIControlStateNormal];
            UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"支付" target:self action:@selector(rightAction)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
            break;
        case CertificateStatusUnderway: // 认证中
        {
            [self.topBtn setTitle:@"认证中" forState:UIControlStateNormal];
        }
            break;
        case CertificateStatusFailure: // 认证失败
        {
            [self.topBtn setTitle:@"认证未通过" forState:UIControlStateNormal];
            self.timeLabel.text = [NSString stringWithFormat:@"原因：%@", self.model.reason];
            self.timeLabel.hidden = NO;
            self.timeLabel.font = [UIFont systemFontOfSize:14];
            UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"重新认证" target:self action:@selector(rightAction)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
            break;
        case CertificateStatusTimeOut: // 认证过期
        {
            self.timeLabel.hidden = NO;
            [self.topBtn setTitle:@"认证过期" forState:UIControlStateNormal];
            UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"重新认证" target:self action:@selector(rightAction)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
            break;
            
        case CertificateStatusSuccess: // 认证通过
        {
            self.timeLabel.hidden = NO;
            [self.topBtn setTitle:@"认证通过" forState:UIControlStateNormal];
        }
            break;
        case CertificateStatusUnknown: // 未认证过
        {
            [self.topBtn setTitle:@"未认证" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)rightAction {
    
    // 认证信息
    
    if (self.model.status == CertificateStatusFailure || self.model.status == CertificateStatusTimeOut) {
        // 重新认证
        CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
        VC.companyId = self.companyId;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (self.model.status ==  CertificateStatusSuccess) {
        CertificateInformationViewController *vc = [[CertificateInformationViewController alloc] initWithNibName:@"CertificateInformationViewController" bundle:nil];
        vc.model = self.model;
        vc.companyId = self.companyId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.model.status ==  CertificateStatusUnPay) {
        CertificationPayController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificationPayController"];
        VC.companyId = self.companyId;
        MJWeakSelf;
        VC.successBlock = ^{
            [weakSelf.topBtn setTitle:@"认证中" forState:UIControlStateNormal];
            weakSelf.model.status = CertificateStatusUnderway;
            UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"认证信息" target:self action:@selector(rightAction)];
            weakSelf.navigationItem.rightBarButtonItem = rightItem;
        };
        [self.navigationController pushViewController:VC animated:YES];
        
    } else {
        CertificateInformationViewController *vc = [[CertificateInformationViewController alloc] initWithNibName:@"CertificateInformationViewController" bundle:nil];
        vc.model = self.model;
        vc.companyId = self.companyId;
        [self.navigationController pushViewController:vc animated:YES];
        
//        CertificateStatusController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificateStatusController"];
//        VC.cModel = self.model;
//        VC.companyId = self.companyId;
//        [self.navigationController pushViewController:VC animated:YES];
    }
}


- (IBAction)topBtnAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
