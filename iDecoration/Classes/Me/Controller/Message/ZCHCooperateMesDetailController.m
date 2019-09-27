//
//  ZCHCooperateMesDetailController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCooperateMesDetailController.h"
#import "ZCHCooperateListModel.h"
#import "UploadAdvertisementController.h"
#import "ZCHApplyCooperateMsgDetailCell.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"


static NSString *reuseIdentifier = @"ZCHApplyCooperateMsgDetailCell";
@interface ZCHCooperateMesDetailController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ZCHCooperateMesDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"企业申请";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHApplyCooperateMsgDetailCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    [self.view addSubview:self.tableView];
    [self addFootView];
}

- (void)addFootView {
    
    UIView *bgView = [[UIView alloc] init];
    if ([self.model.applyStatus isEqualToString:@"0"]) {//0.未处理 1.拒绝、2.忽略、3.同意、4.拉黑
        bgView.frame = CGRectMake(0, 0, BLEJWidth, 180);
        bgView.backgroundColor = White_Color;
        
        UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
        agreeBtn.tag = 3;
//        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [agreeBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        [agreeBtn addTarget:self action:@selector(didClickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [bgView addSubview:agreeBtn];
        
        UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(10, agreeBtn.bottom, BLEJWidth - 20, 1)];
        lineOne.backgroundColor = kBackgroundColor;
        [bgView addSubview:lineOne];
        
        UIButton *refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, lineOne.bottom, BLEJWidth, 44)];
        refuseBtn.tag = 1;
        //        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [refuseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [refuseBtn addTarget:self action:@selector(didClickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [bgView addSubview:refuseBtn];
        
        UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(10, refuseBtn.bottom, BLEJWidth - 20, 1)];
        lineTwo.backgroundColor = kBackgroundColor;
        [bgView addSubview:lineTwo];
        
        UIButton *ignoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, lineTwo.bottom, BLEJWidth, 44)];
        ignoreBtn.tag = 2;
        //        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [ignoreBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        [ignoreBtn addTarget:self action:@selector(didClickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [ignoreBtn setTitle:@"忽略" forState:UIControlStateNormal];
        [bgView addSubview:ignoreBtn];
        
        UIView *lineThree = [[UIView alloc] initWithFrame:CGRectMake(10, ignoreBtn.bottom, BLEJWidth - 20, 1)];
        lineThree.backgroundColor = kBackgroundColor;
        [bgView addSubview:lineThree];
        
        UIButton *blackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, lineThree.bottom, BLEJWidth, 44)];
        blackBtn.tag = 4;
        //        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [blackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [blackBtn addTarget:self action:@selector(didClickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [blackBtn setTitle:@"拉黑" forState:UIControlStateNormal];
        [bgView addSubview:blackBtn];
    } else {
        
        bgView.frame = CGRectMake(0, 0, BLEJWidth, 44);
        bgView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        NSInteger type = [self.model.applyStatus integerValue];
        switch (type) {
            case 1:
                label.text = @"已拒绝该申请";
                break;
            case 2:
                label.text = @"已忽略该申请";
                break;
            case 3:
                label.text = @"已同意该申请";
                break;
            case 4:
                label.text = @"已拉黑该企业";
                break;
            default:
                break;
        }
    }
    
    self.tableView.tableFooterView = bgView;
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHApplyCooperateMsgDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.detailMsgModel = self.model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1065 || [self.model.companyType integerValue] == 1064) {
        
        CompanyDetailViewController *VC = [[CompanyDetailViewController alloc] init];
        VC.companyID = self.model.companyId;
        VC.companyName = self.model.companyName;
        VC.origin = @"2";
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        
        ShopDetailViewController *VC = [[ShopDetailViewController alloc] init];
        VC.shopID = self.model.companyId;
        VC.shopName = self.model.companyName;
        VC.origin = @"2";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}


#pragma mark - 代理方法(处理申请)
- (void)didClickApplyBtn:(UIButton *)btn {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    // 0.未处理、1.拒绝、2.忽略、3.同意、4.拉黑。
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/dealApply.do"];
    NSDictionary *param = @{
                            @"agencyId" : @(agencyid),
                            @"id" : self.model.applyID,
                            @"status" : @(btn.tag)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.navigationController popViewControllerAnimated:YES];
            if (self.block) {
                self.block();
            }
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"处理失败"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
