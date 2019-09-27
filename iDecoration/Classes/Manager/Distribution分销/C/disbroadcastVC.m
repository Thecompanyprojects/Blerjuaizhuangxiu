//
//  disbroadcastVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "disbroadcastVC.h"
#import "disbroadcastCell.h"
#import "SpreadNewsList.h"
#import "declarationcardVC.h"

@interface disbroadcastVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *broadcastIdentfid = @"broadcastIdentfid";

@implementation disbroadcastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"播报详情";
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    [self loaddata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:GET_FENXIAOBOBAO];
    [self.dataSource removeAllObjects];
    [NetManager afGetRequest:url parms:nil finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SpreadNewsList class] json:responseObj[@"data"][@"spreadNewsList"]]];
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
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom)];
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
    disbroadcastCell *cell = [tableView dequeueReusableCellWithIdentifier:broadcastIdentfid];
    cell = [[disbroadcastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:broadcastIdentfid];
    [cell setdata:self.dataSource[indexPath.row]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    SpreadNewsList *model = self.dataSource[index.row];
    if (model.incomeType==0) {
        declarationcardVC *vc = [declarationcardVC new];
        vc.incomeId = model.incomeId;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
@end
