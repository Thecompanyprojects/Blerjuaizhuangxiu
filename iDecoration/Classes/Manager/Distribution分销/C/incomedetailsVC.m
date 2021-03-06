//
//  incomedetailsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "incomedetailsVC.h"
#import "incomedetailsCell1.h"
#import "incomelistModel.h"
#import "teamincommedCell.h"
#import "CashList.h"
#import "declarationcardVC.h"

@interface incomedetailsVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *choosebtn0;
@property (nonatomic,strong) UIButton *choosebtn1;
@property (nonatomic,strong) UIButton *choosebtn2;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *typestr;
@end

static NSString *incomedetailsidentfid0 = @"incomedetailsidentfid0";
static NSString *incomedetailsidentfid1 = @"incomedetailsidentfid1";

@implementation incomedetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收入明细";
    self.typestr = @"1";
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.tableHeaderView = self.headView;
    [self loaddata0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata0
{
    self.typestr = @"1";
    NSString *url = [BASEURL stringByAppendingString:POST_shourumingxi];
    NSString* agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *incomeType = self.typestr;
    NSDictionary *para = @{@"agencyId":agencyId,@"incomeType":incomeType};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        [self.dataSource removeAllObjects];
       
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[incomelistModel class] json:responseObj[@"incomeList"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        else
        {
            NSString *msg = [responseObj objectForKey:@"msg"];
            [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)loaddata1
{
    self.typestr = @"3";
    NSString *url = [BASEURL stringByAppendingString:POST_shourumingxi];
    NSString* agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *incomeType = self.typestr;
    NSDictionary *para = @{@"agencyId":agencyId,@"incomeType":incomeType};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        [self.dataSource removeAllObjects];
      
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[incomelistModel class] json:responseObj[@"incomeList"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        else
        {
            NSString *msg = [responseObj objectForKey:@"msg"];
            [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)loaddata2
{
    NSString *url = [BASEURL stringByAppendingString:POST_FENXIAOTIXIANJILU];
    NSString* agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"agencyId":agencyId};
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        [self.dataSource removeAllObjects];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CashList class] json:responseObj[@"data"][@"cashList"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
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
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
    }
    return _table;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 60);
        [_headView addSubview:self.choosebtn0];
        [_headView addSubview:self.choosebtn1];
        [_headView addSubview:self.choosebtn2];
    }
    return _headView;
}

-(UIButton *)choosebtn0
{
    if(!_choosebtn0)
    {
        _choosebtn0 = [[UIButton alloc] init];
        _choosebtn0.frame = CGRectMake(10, 10, 60, 30);
        [_choosebtn0 setTitleColor:Main_Color forState:normal];
        _choosebtn0.titleLabel.font = [UIFont systemFontOfSize:13];
        [_choosebtn0 setTitle:@"自己收入" forState:normal];
        [_choosebtn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choosebtn0;
}

-(UIButton *)choosebtn1
{
    if(!_choosebtn1)
    {
        _choosebtn1 = [[UIButton alloc] init];
        _choosebtn1.frame = CGRectMake(80, 10, 80, 30);
        [_choosebtn1 setTitleColor:[UIColor darkGrayColor] forState:normal];
        _choosebtn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_choosebtn1 setTitle:@"团队报单卡" forState:normal];
        [_choosebtn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choosebtn1;
}


-(UIButton *)choosebtn2
{
    if(!_choosebtn2)
    {
        _choosebtn2 = [[UIButton alloc] init];
        _choosebtn2.frame = CGRectMake(170, 10, 60, 30);
        [_choosebtn2 setTitleColor:[UIColor darkGrayColor] forState:normal];
        _choosebtn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_choosebtn2 setTitle:@"提现记录" forState:normal];
        [_choosebtn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choosebtn2;
}



-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}



#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    incomedetailsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:incomedetailsidentfid0];
    cell = [[incomedetailsCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:incomedetailsidentfid0];
    if ([self.typestr isEqualToString:@"2"]) {
        [cell settixian:self.dataSource[indexPath.row]];
    }
    else
    {
       
        [cell setdata:self.dataSource[indexPath.row] andwithcelltype:self.typestr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

#pragma mark - 实现方法


-(void)btn0click
{
    [self.choosebtn1 setTitleColor:[UIColor darkGrayColor] forState:normal];
    [self.choosebtn0 setTitleColor:Main_Color forState:normal];
    [self.choosebtn2 setTitleColor:[UIColor darkGrayColor] forState:normal];
    self.typestr = @"1";
    [self loaddata0];
}

-(void)btn1click
{
    [self.choosebtn0 setTitleColor:[UIColor darkGrayColor] forState:normal];
    [self.choosebtn1 setTitleColor:Main_Color forState:normal];
    [self.choosebtn2 setTitleColor:[UIColor darkGrayColor] forState:normal];
    self.typestr = @"3";
    [self loaddata1];
}

-(void)btn2click
{
    [self.choosebtn0 setTitleColor:[UIColor darkGrayColor] forState:normal];
    [self.choosebtn1 setTitleColor:[UIColor darkGrayColor] forState:normal];
    [self.choosebtn2 setTitleColor:Main_Color forState:normal];
    self.typestr = @"2";
    [self loaddata2];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if ([self.typestr isEqualToString:@"2"]) {
        NSString *title = @"暂无提现记录";
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                     NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                     };
        return [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }
    else
    {
        NSString *title = @"暂无收入记录";
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                     NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                     };
        return [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }
    return [NSAttributedString new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.typestr isEqualToString:@"3"]) {
        incomelistModel *model = self.dataSource[indexPath.row];
        declarationcardVC *vc = [declarationcardVC new];
        vc.incomeId = model.incomeId;
        if ([model.incomeMoney isEqualToString:@"500"]) {
            vc.type = @"0";
        }
        else
        {
            vc.type = @"1";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
