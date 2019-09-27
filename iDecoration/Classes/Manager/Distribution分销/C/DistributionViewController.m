//
//  DistributionViewController.m
//  iDecoration
//
//  Created by 丁 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionViewController.h"
#import "DistributionCell0.h"
#import "DistributionCell1.h"
#import "ApplyDistributionVC.h"

@interface DistributionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;
@end

static NSString *distributionidentfid0 = @"distributionidentfid0";
static NSString *distributionidentfid1 = @"distributionidentfid1";
static NSString *distributionidentfid2 = @"distributionidentfid2";

@implementation DistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.InActionType == ENUM_ViewController895_ActionTypejiangli) {
        self.title = @"奖励机制";
    }
    else
    {
        self.title = @"了解分销员";
    }
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    [self layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layout
{
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_offset(46*HEIGHT_SCALE);
        make.left.equalTo(77*WIDTH_SCALE);
        make.top.equalTo(self.footView).with.offset(50*HEIGHT_SCALE);
    }];
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


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        DistributionCell0 *cell = [tableView dequeueReusableCellWithIdentifier:distributionidentfid0];
        if (!cell) {
            cell = [[DistributionCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:distributionidentfid0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        DistributionCell1 *cell = [tableView dequeueReusableCellWithIdentifier:distributionidentfid1];
        if (!cell) {
            cell = [[DistributionCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:distributionidentfid1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:distributionidentfid2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:distributionidentfid2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"申请分销员" forState:normal];
        btn.frame = CGRectMake(kSCREEN_WIDTH/2-111, 20, 222, 46);
        btn.backgroundColor = [UIColor hexStringToColor:@"FC603A"];
        [btn setTitleColor:[UIColor whiteColor] forState:normal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        [cell addSubview:btn];
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 117*HEIGHT_SCALE;
    }
    if (indexPath.row==1) {
        return 850;
    }
    if (indexPath.row==2) {
        return 100;
    }
    return 0.01f;
}

#pragma mark - 实现方法

-(void)submitbtnclick
{
    if ([self.type isEqualToString:@"1"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"您已经是分销员了" controller:self sleep:1.5];
    }
    if ([self.type isEqualToString:@"3"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"您的信息正在审核中，请耐心等待" controller:self sleep:1.5];
    }
    if ([self.type isEqualToString:@"2"]||[self.type isEqualToString:@"0"]) {
        ApplyDistributionVC *vc = [ApplyDistributionVC new];
        vc.trueName = self.trueName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
