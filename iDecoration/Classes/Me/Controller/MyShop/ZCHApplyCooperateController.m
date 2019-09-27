//
//  ZCHApplyCooperateController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHApplyCooperateController.h"
#import "ZCHRightImageBtn.h"
#import "ZCHNewLocationController.h"
#import "ZCHCityModel.h"
//#import "ZCHApplyCooperateCell.h"
#import "ZCHCooperateAndUnionCell.h"
#import "ZCHSearchCooperateModel.h"
#import "ZCHCooperateListModel.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "UploadAdvertisementController.h"
#import "VipDetailController.h"
#import "VIPExperienceShowViewController.h"

static NSString *reuseIdentifier = @"ZCHCooperateAndUnionCell";

//extern ZCHCityModel *cityModel;
//extern ZCHCityModel *countyModel;
@interface ZCHApplyCooperateController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZCHCooperateAndUnionCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, strong) UITextField *searchTF;
//@property (strong, nonatomic) UIButton *locationBtn;
@property (strong, nonatomic) ZCHSearchCooperateModel *model;

@end

@implementation ZCHApplyCooperateController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"申请合作";
    [self setUpUI];
    [self getData];
}

#pragma mark - 添加navBar右侧的编辑按钮
- (void)setUpUI {
    
//    // 设置导航栏最右侧的按钮
//    self.locationBtn = [[ZCHRightImageBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    [self.locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    if (IPhone4) {
//        self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    } else if (IPhone5) {
//        self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    } else {
//        self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    }
//    [self.locationBtn setTitle:countyModel ? countyModel.name : cityModel.name forState:UIControlStateNormal];
//    [self.locationBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
//    [self.locationBtn addTarget:self action:@selector(didClickLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
//    self.navigationItem.rightBarButtonItem = rightbarItem;
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom + 11, kSCREEN_WIDTH-20, 36)];
    self.searchTF.delegate = self;
    self.searchTF.backgroundColor = White_Color;
    self.searchTF.layer.borderColor = Bottom_Color.CGColor;
    self.searchTF.layer.cornerRadius = 5;
    self.searchTF.layer.borderWidth = 1;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = @"请输入公司号/公司名称";
    
    [self.view addSubview:self.searchTF];
    
    [[PublicTool defaultTool] publicToolsAddLeftViewWithTextField:self.searchTF];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.searchTF.mas_top).offset(5);
        make.left.equalTo(self.searchTF.mas_right).offset(-27);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchTF.bottom + 9, kSCREEN_WIDTH, kSCREEN_HEIGHT-(self.searchTF.bottom + 9)) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHCooperateAndUnionCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    [self.view addSubview:self.tableView];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.model) {
        
        return self.model.companyList.count;
    } else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCooperateAndUnionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.currentCompanyId = self.companyId;
    cell.model = self.model.companyList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCooperateListModel *model = [self.model.companyList objectAtIndex:indexPath.row];
    ZCHCooperateAndUnionCell *companyCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([model.appVip isEqualToString:@"1"]) {
        //公司的详情
        if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
            CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
            company.companyName = model.companyName;
            company.companyID = model.companyId;
            company.origin = @"2";
            [self.navigationController pushViewController:company animated:YES];
        } else {
            //店铺的详情;
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = model.companyName;
            shop.shopID = model.companyId;
            model.browse = [NSString stringWithFormat:@"%ld", model.browse.integerValue + 1];
            shop.shopLogo = companyCell.logoView.image;
            shop.origin = @"2";
            [self.navigationController pushViewController:shop animated:YES];
        }
    } else {
        VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
        controller.isEdit = false;
        controller.companyId = model.companyId;
        controller.origin = @"2";
        [self.navigationController pushViewController:controller animated:true];
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司未开通企业网会员"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 86;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}


//#pragma mark - 点击事件
//// 定位
//- (void)didClickLocationBtn:(UIButton *)btn {
//
//    [self.searchTF resignFirstResponder];
//    ZCHNewLocationController *locationVC = [[ZCHNewLocationController alloc] init];
//    __weak typeof(self) weakSelf = self;
//    locationVC.refreshBlock = ^() {
//
//        [weakSelf.locationBtn setTitle:countyModel ? countyModel.name : cityModel.name forState:UIControlStateNormal];
//        [weakSelf getData];
//    };
//    [self.navigationController pushViewController:locationVC animated:YES];
//}

#pragma mark - 搜索按钮点击事件
- (void)searchClick:(UIButton *)sender {
    
    [self textFieldShouldReturn:self.searchTF];
}

#pragma mark - UITextFieldDelegate
// 输入搜索内容之后进行页面的刷新
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self getData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}


#pragma mark - 获取数据
- (void)getData {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/getEnterpriseList.do"];
    YSNLog(@"%@", self.searchTF.text);
    NSDictionary *param;
//                        @{
//                            @"companyId" : self.companyId,
//                            @"companyName" : self.searchTF.text,
//                            @"agencyId" : @(agencyid),
////                            @"companyProvince" : cityModel.pid,
////                            @"companyCity" : cityModel.cityId,
////                            @"companyCounty" : countyModel ? countyModel.cityId : @"0"
//                            @"companyProvince" : self.companyModel.companyProvince,
//                            @"companyCity" : self.companyModel.companyCity,
//                            @"companyCounty" : self.companyModel.companyCounty
//                            };
    
    if ([self.searchTF.text isEqualToString:@""]) {
        param = @{
                  @"companyId" : self.companyId,
                  @"agencyId" : @(agencyid),
                  @"companyProvince" : self.companyModel.companyProvince,
                  @"companyCity" : self.companyModel.companyCity,
                  @"companyCounty" : self.companyModel.companyCounty
                  };
    } else {
        param = @{
                  @"companyId" : self.companyId,
                  @"companyName" : self.searchTF.text,
                  @"agencyId" : @(agencyid),
                  @"companyProvince" : self.companyModel.companyProvince,
                  @"companyCity" : self.companyModel.companyCity,
                  @"companyCounty" : self.companyModel.companyCounty
                  };
    }
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            self.model = [ZCHSearchCooperateModel yy_modelWithJSON:responseObj[@"data"]];
            
        } else if (responseObj && [responseObj[@"code"] integerValue] == 1001) {// 空数据
            
            self.model = [ZCHSearchCooperateModel yy_modelWithJSON:responseObj[@"data"]];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"未搜到相关信息"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取列表数据失败"];
        }
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (UserInfoModel*)publicToolsGetUserInfoModelFromDict {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
    UserInfoModel *user = [UserInfoModel yy_modelWithJSON:dict];
    
    return user;
}

#pragma mark - 代理方法(申请按钮的点击事件)
- (void)didClickApplyBtnWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"impl"] integerValue];
//    if (num != 1) {
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您没有申请权限"];
//        return;
//    }

//    if (![@[@"1002", @"1003", @"1027"] containsObject:self.model.jobType] || num != 1) {// 总经理  经理 店面经理
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您没有申请权限"];
//        return;
//    }

    if (!self.model.flag) {// 总经理  经理 店面经理
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您没有申请权限"];
        return;
    }

    if (self.model.sloganLogo == nil || [self.model.sloganLogo isEqualToString:@""]) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"去上传" message:@"您还没有上传合作企业图" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                // 广告图管理
                UploadAdvertisementController *VC = [[UploadAdvertisementController alloc] init];
                VC.companyID = self.companyId;
//                VC.isShop = self.isShop;
                MJWeakSelf;
                VC.backBlock = ^() {
                    
                    [weakSelf getData];
                };
                [self.navigationController pushViewController:VC animated:YES];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"上传", nil];
        [alertView show];
        return;
    }
    
//    if ([self.model.appVip integerValue] != 1) {
//        
//        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您公司还未开通企业网会员，是否去开通?" message:@"" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//            
//            if (buttonIndex == 1) {
//                
//                __weak typeof(self) weakSelf = self;
//                VipDetailController *vipVC = [UIStoryboard storyboardWithName:@"VipDetailController" bundle:nil].instantiateInitialViewController;
//                
//                vipVC.companyId = self.companyId;
//                vipVC.successBlock = ^() {
//                    
//                    [weakSelf getData];
//                };
//                [self.navigationController pushViewController:vipVC animated:YES];
//            }
//        } cancelButtonTitle:@"下次再说" otherButtonTitles:@"去开通", nil];
//        [alertView show];
//        return;
//    }
    
    
    ZCHCooperateListModel *model = self.model.companyList[indexPath.row];
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/applyCooperate.do"];
    NSDictionary *param = @{
                            @"applyCompanyId" : model.companyId,
                            @"agencyName" : [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict].trueName,
                            @"agencyId" : @(agencyid),
                            @"companyId" : self.companyId
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"申请成功，等待对方同意"];
            [self getData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"申请失败"];
        }
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
