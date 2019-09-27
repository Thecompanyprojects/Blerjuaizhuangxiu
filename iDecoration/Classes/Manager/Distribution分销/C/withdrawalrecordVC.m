//
//  withdrawalrecordVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "withdrawalrecordVC.h"
#import "incomedetailsCell.h"

@interface withdrawalrecordVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *choosebtn0;
@end

static NSString *withdrawalrecordidentfid = @"withdrawalrecordidentfid";

@implementation withdrawalrecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现记录";
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
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
        _table.emptyDataSetDelegate = self;
        _table.emptyDataSetSource = self;
    }
    return _table;
}


-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 55)];
        [_headView addSubview:self.line];
        [_headView addSubview:self.choosebtn0];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

-(UIButton *)choosebtn0
{
    if(!_choosebtn0)
    {
        _choosebtn0 = [[UIButton alloc] init];
        _choosebtn0.frame = CGRectMake(12, 15, 61, 14);
        [_choosebtn0 setTitle:@"提现记录" forState:normal];
        [_choosebtn0 setTitleColor:[UIColor hexStringToColor:@"24B764"] forState:normal];
        _choosebtn0.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _choosebtn0;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
        _line.frame = CGRectMake(0, 50, kSCREEN_WIDTH, 5);
    }
    return _line;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    incomedetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:withdrawalrecordidentfid];
    if (!cell) {
        cell = [[incomedetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawalrecordidentfid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无提现记录";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

@end
