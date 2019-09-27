//
//  ZCHCooperateBlackNameController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCooperateBlackNameController.h"
//#import "ZCHBlackNameCell.h"
#import "ZCHCooperateListModel.h"
#import "YellowPageCompanyTableViewCell.h"
#import "YellowPageShopTableViewCell.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "VIPExperienceShowViewController.h"

//static NSString *reuseIdentifier = @"ZCHBlackNameCell";
static NSString *reuseShopIdentifier = @"shop";
static NSString *reuseCompanyIdentifier = @"company";
@interface ZCHCooperateBlackNameController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation ZCHCooperateBlackNameController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"黑名单";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHBlackNameCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"YellowPageShopTableViewCell" bundle:nil] forCellReuseIdentifier:reuseShopIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"YellowPageCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:reuseCompanyIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self getData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ZCHBlackNameCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.model = self.dataArr[indexPath.row];
//    
//    return cell;
    
    ZCHCooperateListModel *model = self.dataArr[indexPath.row];
    if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
        YellowPageCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCompanyIdentifier forIndexPath:indexPath];
        
        cell.cooperateModel = model;
        return cell;
    } else {
        
        YellowPageShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseShopIdentifier forIndexPath:indexPath];
        
        cell.cooperateModel = model;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCooperateListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    if ([model.appVip isEqualToString:@"1"]) {
        //公司的详情
        if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
            CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
            company.companyName = model.companyName;
            company.companyID = model.companyId;
            company.hidesBottomBarWhenPushed = YES;
            company.origin = @"2";
            [self.navigationController pushViewController:company animated:YES];
        } else {
            //店铺的详情;
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = model.companyName;
            shop.shopID = model.companyId;
            model.browse = [NSString stringWithFormat:@"%ld", model.browse.integerValue + 1];
            YellowPageShopTableViewCell *cell = (YellowPageShopTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.browseNumberLabel.text = model.browse;
            shop.hidesBottomBarWhenPushed = YES;
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

//是否允许编辑，默认值是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"移除黑名单";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ZCHCooperateListModel *model = self.dataArr[indexPath.row];
        [self fireCooperateWithModel:model];
    }
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    MySiteModel *model = self.siteArray[indexPath.section];
//    __weak typeof(self) weakSelf = self;
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"删除工地?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//            
//            if (buttonIndex == 1) {
//                
//                //这个按钮需要处理的代码块
//                [weakSelf deleteConstructionWithIndex:indexPath];
//            }
//        } cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
//        [alertView show];
//    }];
//    
//    
//    if ([model.isTop integerValue] == 0) {
//        
//        UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//            
//            //这个按钮需要处理的代码块
//            [weakSelf setTopConstructionWithIndex:indexPath];
//        }];
//        topAction.backgroundColor = [UIColor lightGrayColor];
//        if ([model.positionNumber integerValue] > 0) {
//            
//            return [NSArray arrayWithObjects:deleteAction, topAction, nil];
//        } else {
//            
//            return [NSArray arrayWithObjects:topAction, nil];
//        }
//    } else {
//        
//        UITableViewRowAction *cancelTopAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//            
//            //这个按钮需要处理的代码块
//            [weakSelf cancelTopConstructionWithIndex:indexPath];
//        }];
//        cancelTopAction.backgroundColor = [UIColor lightGrayColor];
//        if ([model.positionNumber integerValue] > 0) {
//            
//            return [NSArray arrayWithObjects:deleteAction, cancelTopAction, nil];
//        } else {
//            
//            return [NSArray arrayWithObjects:cancelTopAction, nil];
//        }
//    }
//}



#pragma mark - 获取数据
- (void)getData {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/getCompanyListByCompanyId.do"];
    NSDictionary *param = @{
                            @"companyId" : self.companyId,
                            @"status" : @"4",
                            @"agencyId" : @(agencyid)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArr removeAllObjects];
            self.dataArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCooperateListModel class] json:responseObj[@"data"][@"companyList"]]];
            
        } else if (responseObj && [responseObj[@"code"] integerValue] == 1001) {// 空数据
            
            [self.dataArr removeAllObjects];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取列表数据失败"];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
}

#pragma mark - 移除黑名单
- (void)fireCooperateWithModel:(ZCHCooperateListModel *)model {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/cancelBlack.do"];
    NSDictionary *param = @{
                            @"id" : model.applyID,
                            @"status" : @"0",
                            @"agencyId" : @(agencyid)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self getData];
            
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"移除失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}





- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
