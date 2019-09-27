//
//  distributionenvelopeVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/1.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionenvelopeVC.h"
#import "distributionenvelopeHeaderView.h"
#import "distributionenvelopeCell.h"
#import "RedPacketList.h"
#import "DistributionwithdrawalVC.h"
#import "envelopemessageVC.h"


@interface distributionenvelopeVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) distributionenvelopeHeaderView *headerView;
@property (nonatomic,copy) NSString * moneyTotal;
@property (nonatomic,copy) NSString * cashMoney;
@property (nonatomic,copy) NSString * token;
@end

static NSString *envelopeidentfid = @"envelopeidentfid";


@implementation distributionenvelopeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"红包管理";
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.tableHeaderView = self.headerView;
    [self loaddata];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"fenxiaohongbaotixian" object:nil];
}

-(void)notice:(id)sender
{
    [self loaddata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:GET_redPacketManagerInfo];
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"agencyId":agencyId};
    self.dataSource = [NSMutableArray array];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.moneyTotal = [NSString stringWithFormat:@"%@",[responseObj objectForKey:@"moneyTotal"]];
            self.token = [NSString stringWithFormat:@"%@",[responseObj objectForKey:@"token"]];
            self.cashMoney = [NSString stringWithFormat:@"%@",[responseObj objectForKey:@"cashMoney"]];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[RedPacketList class] json:responseObj[@"redPacketList"]]];
            [self.dataSource addObjectsFromArray:data];
            
            [self.headerView setdata:self.moneyTotal and:self.cashMoney];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - getters

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

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

-(distributionenvelopeHeaderView *)headerView
{
    if(!_headerView)
    {
        _headerView = [[distributionenvelopeHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 332);
        [_headerView.submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    distributionenvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:envelopeidentfid];
    cell = [[distributionenvelopeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:envelopeidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedPacketList *model = self.dataSource[indexPath.row];
    if (model.reason.length==0) {
        return 88.0f;
    }
    else
    {
        return 103;
    }
    return 88.0f;
}

#pragma mark -  实现方法

-(void)submitbtnclick
{
    DistributionwithdrawalVC *vc = [DistributionwithdrawalVC new];
    vc.userName = self.userName;
    vc.type = @"2";
    vc.accountTotal = self.cashMoney;
    vc.token = self.token;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    RedPacketList *model = self.dataSource[index.row];
    envelopemessageVC *vc = [envelopemessageVC new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
