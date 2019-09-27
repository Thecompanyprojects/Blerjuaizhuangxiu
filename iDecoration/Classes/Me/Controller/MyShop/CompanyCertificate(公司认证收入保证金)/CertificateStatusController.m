//
//  CertificateStatusController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CertificateStatusController.h"
#import "CompanyCertificationController.h"
#import "CertificationPayController.h"

@interface CertificateStatusController ()

@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;

@property (weak, nonatomic) IBOutlet UITextField *certificateCodeTF;

@property (weak, nonatomic) IBOutlet UITextField *legalPersonTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *faileReasonLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightCon;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;


@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *rightPayItem;

@end

@implementation CertificateStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业认证";
    
    self.rightPayItem = [UIBarButtonItem rightItemWithTitle:@"支付" target:self action:@selector(payAction)];
    self.rightItem = [UIBarButtonItem rightItemWithTitle:@"重新认证" target:self action:@selector(reCertificateAction)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.companyNameTF.text = self.cModel.companyName;
    self.legalPersonTF.text = self.cModel.personName;
    self.certificateCodeTF.text = self.cModel.regCode;
    
    NSString *adoptTime = [NSDate yearMoneyDayFromTimeInterval:self.cModel.adoptTime/1000.0];
    NSString *overTime = [NSDate yearMoneyDayFromTimeInterval:self.cModel.overdueDate/1000.0];
    self.timeTF.text = [NSString stringWithFormat:@"%@ - %@", adoptTime, overTime];
    
    self.imageViewHeightCon.constant = 26;
    self.imageViewWidthCon.constant = 23;
    self.imageViewTopCon.constant = 48;
    self.imageView.image = [UIImage imageNamed:@"bg_daishenhe"];
    self.timeCell.hidden = YES;
    self.faileReasonLabel.hidden = YES;
    switch (self.cModel.status) {
        case CertificateStatusUnderway: // 认证中
        {
            self.navigationItem.rightBarButtonItem = nil;
            self.titleLabel.text = @"您的企业认证待审核";
            self.timeTF.text = @"";
        }
            break;
        case CertificateStatusSuccess: // 认证通过
        {
            self.imageViewWidthCon.constant = 104;
            self.imageViewHeightCon.constant = 77;
            self.imageViewTopCon.constant = 28;
             [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.cModel.licenseImg] placeholderImage:[UIImage imageNamed:@"bg_zhizhao_renzhengchenggong"]];
            self.timeCell.hidden = NO;
            self.navigationItem.rightBarButtonItem = self.rightItem;
            self.titleLabel.text = @"您的企业已认证成功";
        }
            break;
        case CertificateStatusUnPay: // 未支付
        {
            self.navigationItem.rightBarButtonItem = self.rightPayItem;
            self.titleLabel.text = @"您的企业尚未交取认证费用";
            self.timeTF.text = @"";
        }
            break;
        case CertificateStatusFailure: // 认证失败
        {
            self.navigationItem.rightBarButtonItem = self.rightItem;
            self.titleLabel.text = @"您的企业认证未通过";
            self.titleLabel.textColor = kCustomColor(242, 158, 75);
            self.timeTF.text = @"";
            self.faileReasonLabel.hidden = NO;
            self.faileReasonLabel.text = [NSString stringWithFormat:@"原因：%@", self.cModel.reason];
        }
            break;
        case CertificateStatusTimeOut: // 认证过期
        {
            self.timeCell.hidden = NO;
            self.navigationItem.rightBarButtonItem = self.rightItem;
            self.titleLabel.text = @"您的企业认证已过期";
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reCertificateAction {
    CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.companyId;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)payAction {
    CertificationPayController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificationPayController"];
    VC.companyId = self.companyId;
    MJWeakSelf;
    VC.successBlock = ^{
        weakSelf.navigationItem.rightBarButtonItem = nil;
        weakSelf.titleLabel.text = @"您的企业认证待审核";
        weakSelf.timeTF.text = @"";
    };
    [self.navigationController pushViewController:VC animated:YES];
}

@end
