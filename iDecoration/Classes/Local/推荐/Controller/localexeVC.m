//
//  localexeVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localexeVC.h"
#import "localexeCell.h"
#import "localexeModel.h"
#import "NewsActivityShowController.h"

@interface localexeVC ()<UITableViewDataSource,UITableViewDelegate,LYShareMenuViewDelegate>
{
    int pagenum;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *table;


@end

static NSString *localexeidentfid = @"localexeidentfid";

@implementation localexeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"装修攻略";
    

    
    pagenum = 1;
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewData
{
    pagenum = 1;
    NSString *url = [BASEURL stringByAppendingString:GET_getExcellentCase];
    NSString *page = @"1";
    NSDictionary *para = @{@"page":page};
    [self.dataSource removeAllObjects];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        NSMutableArray *arr = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localexeModel class] json:responseObj[@"data"][@"exeList"]];
        [self.dataSource addObjectsFromArray:arr];
        [self.table reloadData];
        [self.table.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    pagenum++;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *url = [BASEURL stringByAppendingString:GET_getExcellentCase];
    NSDictionary *para = @{@"page":page};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        
        NSMutableArray *arr = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localexeModel class] json:responseObj[@"data"][@"exeList"]];
        [self.dataSource addObjectsFromArray:arr];
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
    }
    return _table;
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
    localexeCell *cell = [tableView dequeueReusableCellWithIdentifier:localexeidentfid];
    cell = [[localexeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localexeidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    localexeModel *model = self.dataSource[indexPath.row];
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.designsId = model.designId;
    vc.activityType = 2;
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}



@end
