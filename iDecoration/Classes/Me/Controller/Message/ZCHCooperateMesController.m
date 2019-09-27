//
//  ZCHCooperateMesController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCooperateMesController.h"
#import "ZCHApplyCooperateCell.h"
#import "ZCHCooperateListModel.h"
#import "ZCHCooperateMesDetailController.h"
#import "UploadAdvertisementController.h"
#import "VipDetailController.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"

static NSString *reuseIdentifier = @"ZCHApplyCooperateCell";
@interface ZCHCooperateMesController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZCHApplyCooperateCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ZCHCooperateMesController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"合作企业";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHApplyCooperateCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHApplyCooperateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.msgModel = self.dataArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCooperateListModel *model = self.dataArr[indexPath.row];
    if (model.sloganLogo == nil || [model.sloganLogo isEqualToString:@""]) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"去上传" message:@"您还没有上传合作企业图" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                // 广告图管理
                UploadAdvertisementController *VC = [[UploadAdvertisementController alloc] init];
                VC.companyID = model.applyCompanyId;
//                VC.isShop = ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) ? NO : YES;
                MJWeakSelf;
                VC.backBlock = ^() {
                    _page = 1;
                    [weakSelf getData];
                };
                [self.navigationController pushViewController:VC animated:YES];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"上传", nil];
        [alertView show];
        return;
    }
    
//    if ([model.appVip integerValue] != 1) {
//        
//        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您公司还未开通企业网会员，是否去开通?" message:@"" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//            
//            if (buttonIndex == 1) {
//                
//                __weak typeof(self) weakSelf = self;
//                VipDetailController *vipVC = [UIStoryboard storyboardWithName:@"VipDetailController" bundle:nil].instantiateInitialViewController;
//                
//                vipVC.companyId = model.applyCompanyId;
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
    
    ZCHCooperateMesDetailController *detailVC = [[ZCHCooperateMesDetailController alloc] init];
    detailVC.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    detailVC.block = ^() {
        _page = 1;
        [weakSelf getData];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

//是否允许编辑，默认值是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"删除后不可恢复，是否确认删除?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                //这个按钮需要处理的代码块
                __weak typeof(self) weakSelf = self;
                ZCHCooperateListModel *model = self.dataArr[indexPath.row];
                [weakSelf deleteCooperateWithModel:model];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

#pragma mark - 获取数据
- (void)getData {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/getApplyWordsByAgencyId.do"];
    NSDictionary *param = @{
                            @"agencyId" : @(agencyid),
                            @"page": @(_page),
                            @"pageSize": @(30)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            if (_page == 1) {
                [self.dataArr removeAllObjects];
            }
            NSArray *array = [NSArray yy_modelArrayWithClass:[ZCHCooperateListModel class] json:responseObj[@"data"][@"companyList"]];
            [self.dataArr addObjectsFromArray:array];
        } else if (responseObj && [responseObj[@"code"] integerValue] == 1001) {
            
            [self.dataArr removeAllObjects];
            
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取失败"];
        }
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
}

#pragma mark - 代理方法(同意申请)
- (void)didClickApplyBtnWithIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCooperateListModel *model = self.dataArr[indexPath.row];
    if (model.sloganLogo == nil || [model.sloganLogo isEqualToString:@""]) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"去上传" message:@"您还没有上传合作企业图" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                // 广告图管理
                UploadAdvertisementController *VC = [[UploadAdvertisementController alloc] init];
                VC.companyID = model.applyCompanyId;
//                VC.isShop = ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) ? NO : YES;
                MJWeakSelf;
                VC.backBlock = ^() {
                    _page = 1;
                    [weakSelf getData];
                };
                [self.navigationController pushViewController:VC animated:YES];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"上传", nil];
        [alertView show];
        return;
    }
    
//    if ([model.appVip integerValue] != 1) {
//        
//        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您公司还未开通企业网会员，是否去开通?" message:@"" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//            
//            if (buttonIndex == 1) {
//                
//                __weak typeof(self) weakSelf = self;
//                VipDetailController *vipVC = [UIStoryboard storyboardWithName:@"VipDetailController" bundle:nil].instantiateInitialViewController;
//                
//                vipVC.companyId = model.applyCompanyId;
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
    
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/dealApply.do"];
    NSDictionary *param = @{
                            @"agencyId" : @(agencyid),
                            @"id" : model.applyID,
                            @"status" : @(3)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            _page = 1;
            [self getData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"处理失败"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (void)didClickCompanyLogoIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCooperateListModel *model = self.dataArr[indexPath.row];
    if ([model.companyType integerValue] == 1018 || [model.companyType integerValue] == 1065 || [model.companyType integerValue] == 1064) {
        
        CompanyDetailViewController *VC = [[CompanyDetailViewController alloc] init];
        VC.companyID = model.companyId;
        VC.companyName = model.companyName;
        VC.origin = @"2";
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        
        ShopDetailViewController *VC = [[ShopDetailViewController alloc] init];
        VC.shopID = model.companyId;
        VC.shopName = model.companyName;
        VC.origin = @"2";
        [self.navigationController pushViewController:VC animated:YES];
    }
}


- (void)deleteCooperateWithModel:(ZCHCooperateListModel *)model {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/deleteMessage.do"];
    NSDictionary *param = @{
                            @"id" : model.applyID
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            _page = 1;
            [self getData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"删除失败"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
