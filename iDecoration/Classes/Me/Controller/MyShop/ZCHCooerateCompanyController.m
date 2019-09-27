//
//  ZCHCooerateCompanyController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCooerateCompanyController.h"
#import "YellowPageShopTableViewCell.h"
#import "YellowPageCompanyTableViewCell.h"
#import "ZCHApplyCooperateController.h"
#import "ZCHCooperateBlackNameController.h"
#import "ZCHCooperateListModel.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "VIPExperienceShowViewController.h"
#import "ZCHPublicWebViewController.h"

static NSString *reuseShopIdentifier = @"shop";
static NSString *reuseCompanyIdentifier = @"company";
@interface ZCHCooerateCompanyController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation ZCHCooerateCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合作企业";
    [self setUpUI];
    [self getData];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    [self addSuspendedButton];
}

#pragma mark - 添加navBar右侧的编辑按钮
- (void)setUpUI {
    
    // 设置导航栏最右侧的按钮
    UIButton *blackNameBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    blackNameBtn.frame = CGRectMake(0, 0, 44, 44);
    [blackNameBtn setTitle:@"黑名单" forState:UIControlStateNormal];
    [blackNameBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    blackNameBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    blackNameBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    blackNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [blackNameBtn addTarget:self action:@selector(didClickBlackNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:blackNameBtn];
    
    UIButton *applyBtn = [[UIButton alloc] init];
    if (BLEJHeight > 736) {
        
        applyBtn.frame = CGRectMake(0, BLEJHeight - 59, BLEJWidth, 59);
        [applyBtn setBackgroundColor:kBackgroundColor];
        [applyBtn addTarget:self action:@selector(didClickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyBtn];
        
        UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 50, 10, 24, 24)];
        addImage.image = [UIImage imageNamed:@"greenAddBtn"];
        [applyBtn addSubview:addImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(addImage.right + 10, 0, 100, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kMainThemeColor;
        label.text = @"申请合作";
        label.font = [UIFont systemFontOfSize:16];
        [applyBtn addSubview:label];
    } else {
        
        applyBtn.frame = CGRectMake(0, BLEJHeight - 44, BLEJWidth, 44);
        [applyBtn setBackgroundColor:kBackgroundColor];
        [applyBtn addTarget:self action:@selector(didClickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyBtn];
        
        UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 50, 10, 24, 24)];
        addImage.image = [UIImage imageNamed:@"greenAddBtn"];
        [applyBtn addSubview:addImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(addImage.right + 10, 0, 100, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kMainThemeColor;
        label.text = @"申请合作";
        label.font = [UIFont systemFontOfSize:16];
        [applyBtn addSubview:label];
    }
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom - applyBtn.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = White_Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YellowPageShopTableViewCell" bundle:nil] forCellReuseIdentifier:reuseShopIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"YellowPageCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:reuseCompanyIdentifier];
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self setAssistiveTouch];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [self AssistiveTouchDisMiss];
}

-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = INSTRCTIONHTML;
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCooperateListModel *model = self.dataArr[indexPath.row];
//    if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
//        YellowPageCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCompanyIdentifier forIndexPath:indexPath];
//        cell.cooperateModel = model;
//        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15, 85.5, kSCREEN_WIDTH-15, 0.5)];
//        lineV.backgroundColor = kSepLineColor;
//        [cell addSubview:lineV];
//        return cell;
//    } else {
        YellowPageShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseShopIdentifier forIndexPath:indexPath];
        cell.cooperateModel = model;
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15, 85.5, kSCREEN_WIDTH-15, 0.5)];
        lineV.backgroundColor = kSepLineColor;
        [cell addSubview:lineV];
        return cell;
//    }
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
    return 10;
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
    return @"解除合作";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ZCHCooperateListModel *model = self.dataArr[indexPath.row];
        [self fireCooperateWithModel:model];
    }
}

#pragma mark - 点击事件
// 黑名单
- (void)didClickBlackNameBtn:(UIButton *)btn {
    
    ZCHCooperateBlackNameController *blackNameVC = [[ZCHCooperateBlackNameController alloc] init];
    blackNameVC.companyId = self.companyId;
    [self.navigationController pushViewController:blackNameVC animated:YES];
}

// 申请合作
- (void)didClickApplyBtn:(UIButton *)btn {
    
    ZCHApplyCooperateController *applyCooperateVC = [[ZCHApplyCooperateController alloc] init];
    applyCooperateVC.companyId = self.companyId;
    applyCooperateVC.isShop = self.isShop;
    applyCooperateVC.companyModel = self.companyModel;
    [self.navigationController pushViewController:applyCooperateVC animated:YES];
}


#pragma mark - 获取数据
- (void)getData {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/getCompanyListByCompanyId.do"];
    NSDictionary *param = @{
                            @"companyId" : self.companyId?:@"",
                            @"status" : @"3",
                            @"agencyId" : @(agencyid)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArr removeAllObjects];
            self.dataArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCooperateListModel class] json:responseObj[@"data"][@"companyList"]]];
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
            
        } else if (responseObj && [responseObj[@"code"] integerValue] == 1001) {// 空数据
            
            [self.dataArr removeAllObjects];
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - 64 - 44)];
            
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, BLEJWidth - 100, 30)];
            topLabel.textColor = [UIColor darkGrayColor];
            topLabel.textAlignment = NSTextAlignmentCenter;
            topLabel.font = [UIFont systemFontOfSize:14];
            topLabel.text = @"您还没有合作企业";
            [footView addSubview:topLabel];
            
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, topLabel.bottom, BLEJWidth - 100, 50)];
            bottomLabel.textColor = [UIColor darkGrayColor];
            bottomLabel.textAlignment = NSTextAlignmentCenter;
            bottomLabel.font = [UIFont systemFontOfSize:14];
            bottomLabel.numberOfLines = 2;
            bottomLabel.text = @"申请合作后，您跟对方的店面会互相出现在企业的合作企业里";
            [footView addSubview:bottomLabel];
            
            self.tableView.tableFooterView = footView;
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取列表数据失败"];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
}

#pragma mark - 解除合作
- (void)fireCooperateWithModel:(ZCHCooperateListModel *)model {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/deleteApply.do"];
    NSDictionary *param = @{
                            @"id" : model.applyID
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
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
