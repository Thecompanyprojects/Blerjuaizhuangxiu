//
//  companyprogramVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "companyprogramVC.h"
#import "companyprogramCell.h"
#import "computermanagerVC.h"

@interface companyprogramVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

static NSString *companyprogramidentfid = @"companyprogramidentfid";

@implementation companyprogramVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"企业小程序";
    
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
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundColor = kBackgroundColor;
    }
    return _table;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    companyprogramCell *cell = [tableView dequeueReusableCellWithIdentifier:companyprogramidentfid];
    cell = [[companyprogramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyprogramidentfid];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.nameLab.text = @"爱装修计算器";
        cell.leftImg.image = [UIImage imageNamed:@"icon_jisuanqi_xiaochengxu"];
    }
    if (indexPath.section==1) {
        cell.nameLab.text = @"爱装修施工日志";
        cell.leftImg.image = [UIImage imageNamed:@"icon_riji_xiaocxu"];
    }
    if (indexPath.section==2) {
        cell.nameLab.text = @"爱装修全能网站";
        cell.leftImg.image = [UIImage imageNamed:@"icon_wangzhan_chengxu"];
    }
    if (indexPath.section==3) {
        cell.nameLab.text = @"爱装修小程序说明";
        cell.leftImg.image = [UIImage imageNamed:@"icon_dingzhiban_shuoming"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    view.backgroundColor = kBackgroundColor;
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    view.backgroundColor = kBackgroundColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
    }
    if (indexPath.section==1) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
    }
    if (indexPath.section==2) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
    }
    if (indexPath.section==3) {
        computermanagerVC *vc = [computermanagerVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
