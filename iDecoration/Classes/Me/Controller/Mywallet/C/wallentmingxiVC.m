//
//  wallentmingxiVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "wallentmingxiVC.h"
#import "AndyDropDownList.h"
#import "wallentlistCell.h"
#import "mywalletModel.h"

@interface wallentmingxiVC ()<AndyDropDownDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    int pageint;
}
@property (nonatomic,strong) AndyDropDownList *list;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *type;//0全部，1：打赏2：提现
@end

static NSString *wallentlistidentfid = @"wallentlistidentfid";

@implementation wallentmingxiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = @"全部明细";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"全部" style:UIBarButtonItemStylePlain target:self action:@selector(rightclick)];
    myButton.tintColor = [UIColor hexStringToColor:@"49bc86"];
    self.navigationItem.rightBarButtonItem = myButton;
    
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    
    self.array = [NSArray arrayWithObjects:@"全部明细",@"提现明细",@"打赏明细",nil];
    self.navigationItem.titleView = self.button;
    [self.view addSubview:self.list];
    pageint = 1;
    self.type = @"0";
    
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据方法

-(void)loadNewData
{
    pageint = 1;
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *page = [NSString stringWithFormat:@"%d",pageint];
    [self.dataSource removeAllObjects];
    NSString *url = [BASEURL stringByAppendingString:POST_CHAXUNDASHANG];
    NSDictionary *para = @{@"page":page,@"type":self.type,@"agencysId":agencysId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[mywalletModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
        [self.table.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    pageint++;
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *page = [NSString stringWithFormat:@"%d",pageint];
    NSString *url = [BASEURL stringByAppendingString:POST_CHAXUNDASHANG];
    NSDictionary *para = @{@"page":page,@"type":self.type,@"agencysId":agencysId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[mywalletModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
        [self.table.mj_footer endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_footer endRefreshing];
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

-(AndyDropDownList *)list
{
    if (!_list)
    {
        _list = [[AndyDropDownList alloc]initWithListDataSource:self.array rowHeight:44 view:self.button];
        _list.delegate = self;
    }
    return _list;
}

-(UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button.frame = CGRectMake(88, 0, kSCREEN_WIDTH-88, kNaviBottom);
        [_button setTitle:@"全部明细" forState:UIControlStateNormal];
    }
    return _button;
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
    wallentlistCell *cell = [tableView dequeueReusableCellWithIdentifier:wallentlistidentfid];
    if (!cell) {
        cell = [[wallentlistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wallentlistidentfid];
    }
    [cell setdata:self.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}

#pragma mark -AndyDropDownDelegate

-(void)dropDownListParame:(NSString *)aStr
{
    _button.selected = NO;
    [_button setTitle:[NSString stringWithFormat:@"%@",aStr] forState:UIControlStateNormal];
    if ([aStr isEqualToString:@"全部明细"]) {
        self.type = @"0";
    }
    if ([aStr isEqualToString:@"提现明细"]) {
        self.type = @"2";
    }
    if ([aStr isEqualToString:@"打赏明细"]) {
        self.type = @"1";
    }
    [self loadNewData];
}

-(void)buttonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected == YES)
    {
        [self.list showList];
        
    }else
    {
        [self.list hiddenList];
    }
}

-(void)rightclick
{
    
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无明细";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
@end
