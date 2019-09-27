//
//  RedEnvelopeManagementViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/30.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "RedEnvelopeManagementViewController.h"
#import "RedEnvelopeManagementTableViewCell.h"
#import "RedEnvelopeManagementModel.h"
#import "VipGroupViewController.h"
#import "ZCHCashCouponController.h"

@interface RedEnvelopeManagementViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation RedEnvelopeManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包管理";
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    [self.tableView setBackgroundColor:[UIColor hexStringToColor:@"f2f2f2"]];
}

- (void)viewWillLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(0);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return RedEnvelopeManagementModel.arrayTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedEnvelopeManagementTableViewCell *cell = [RedEnvelopeManagementTableViewCell cellWithTableView:tableView];
    cell.labelTitle.text = RedEnvelopeManagementModel.arrayTitle[indexPath.section];
    [cell.imageViewIcon setImage:[UIImage imageNamed:RedEnvelopeManagementModel.arrayTitleIcon[indexPath.section]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(self)
    if (indexPath.section == 0) {
        if ([self.currentModel.calVip isEqualToString:@"0"]) {
            TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"充值公司号码通" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    // 会员套餐
                    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                    VC.companyId = self.currentModel.companyId;
                    VC.successBlock = ^() {
                        [weakself getCurrentPersonCompanyList];
                    };
                    [self.navigationController pushViewController:VC animated:YES];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        } else {
            ZCHCashCouponController *VC = [[ZCHCashCouponController alloc] init];
            VC.isCanNew = YES;
            //经理，总经理，设计师有权限创建代金券和礼品券
            NSInteger agencyJob = self.currentCompanyModel.agencyJob;
            if (agencyJob==1002||agencyJob==1003||agencyJob==1027||agencyJob==1010||agencyJob==1029||self.currentCompanyModel.implement) {
                VC.isCanNewCoupon = YES;
            }
            else{
                VC.isCanNewCoupon = NO;
            }
            VC.companyId = self.currentModel.companyId;
            VC.companyName = self.currentModel.companyName;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

// 获取当前用户公司列表
- (void)getCurrentPersonCompanyList {
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        return;
    }
    NSString *apiStr = [BASEURL stringByAppendingString:@"statistic/getCompanys.do"];
    UserInfoModel *userInfo = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    NSDictionary *param = @{
                            @"agencyId": @(userInfo.agencyId)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            NSArray *companys = responseObj[@"data"][@"companys"];
            self.currentPersonCompanyArray = [[NSArray yy_modelArrayWithClass:[YGLCurrentPersonCompanyModel class] json:companys] mutableCopy];
            [self getCurrentModel];
        }
    } failed:^(NSString *errorMsg) {

    }];
}

- (void)getCurrentModel {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *requestString = [BASEURL stringByAppendingString:@"company/findCompanyList.do"];
    NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                          };
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            NSDictionary *dict = responseObj[@"data"];
            NSArray *arr = [dict objectForKey:@"companyList"];

            self.curremtModelArray = [[NSArray yy_modelArrayWithClass:[SubsidiaryModel class] json:arr] mutableCopy];

            // 如果是一个公司就直接跳转不弹框选择公司了
            if (self.currentPersonCompanyArray.count == 1) {
                self.currentCompanyModel = self.currentPersonCompanyArray.firstObject;
                self.currentModel = self.curremtModelArray.firstObject;
                self.navigationItem.title = self.currentModel.companyName;
            }

            // 设置标题
            [self.curremtModelArray enumerateObjectsUsingBlock:^(SubsidiaryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.headQuarters.integerValue == 1) {
                    self.navigationItem.title = obj.companyName;
                    *stop = YES;
                }
            }];

        }
    } failed:^(NSString *errorMsg) {

    }];
}
@end
