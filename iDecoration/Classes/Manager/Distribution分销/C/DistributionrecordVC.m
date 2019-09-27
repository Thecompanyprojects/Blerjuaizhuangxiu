//
//  DistributionrecordVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionrecordVC.h"
#import "distributionrecorecordCell.h"
#import "disrecordheadView.h"
#import "DistributionwithdrawalVC.h"

@interface DistributionrecordVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) disrecordheadView *headView;
@end

static NSString *distributionrecordidentfid0 = @"distributionrecordidentfid0";
static NSString *distributionrecordidentfid1 = @"distributionrecordidentfid1";

@implementation DistributionrecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分销记录";
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.headView;
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
    }
    return _table;
}


-(disrecordheadView *)headView
{
    if(!_headView)
    {
        _headView = [[disrecordheadView alloc] init];
        _headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 145*HEIGHT_SCALE);
        [_headView.submitbtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

#pragma mark - getters

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else
    {
        return 4;
        //return self.dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:distributionrecordidentfid0];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:distributionrecordidentfid0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"提现记录";
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = Main_Color;
        return cell;
    }
    if (indexPath.section==1) {
        distributionrecorecordCell *cell = [tableView dequeueReusableCellWithIdentifier:distributionrecordidentfid1];
        if (!cell) {
            cell = [[distributionrecorecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:distributionrecordidentfid1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 40*HEIGHT_SCALE;
    }
    if (indexPath.section==1) {
        return 80*HEIGHT_SCALE;
    }
    return 0.01f;
}

//section头部间距

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - 实现方法

-(void)submitbtnclick
{
    DistributionwithdrawalVC *vc = [DistributionwithdrawalVC new];
    vc.type = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
