//
//  zhuanxiangVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "zhuanxiangVC.h"
#import "zhuanxiangCell.h"
#import "ZCHCalculatorPayController.h"

@interface zhuanxiangVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

static NSString *zhuanxiangidentfifd = @"zhuanxiangidentfid";

@implementation zhuanxiangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分销员专享";
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters


-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom)];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    zhuanxiangCell *cell = [tableView dequeueReusableCellWithIdentifier:zhuanxiangidentfifd];
    if (!cell) {
        cell = [[zhuanxiangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhuanxiangidentfifd];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 600*HEIGHT_SCALE;
}

#pragma mark - 实现方法

-(void)submitbtnclick
{
//    ZCHCalculatorPayController *vc = [ZCHCalculatorPayController new];
//    vc.isNotCompany = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    ZCHCalculatorPayController *VC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
    //__block NSString *companyId = @"0";
//    if (self.currentCompanyModel!= nil &&  self.currentCompanyModel.companyId > 0) {
//        companyId = [NSString stringWithFormat:@"%ld", self.currentCompanyModel.companyId];
//    }
    //UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    VC.isNotCompany = YES;
    VC.companyId = @"0";
    VC.type = @"1";
    MJWeakSelf;
    VC.refreshBlock = ^() {
    };
    [weakSelf.navigationController pushViewController:VC animated:YES];

}

@end
