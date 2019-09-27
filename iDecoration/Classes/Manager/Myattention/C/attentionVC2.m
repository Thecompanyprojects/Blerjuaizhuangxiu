//
//  attentionVC2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "attentionVC2.h"
#import "attentionCell.h"
#import "focusModel2.h"
#import "attentiondetailsVC.h"
#import "attentionheadView.h"

@interface attentionVC2 ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) attentionheadView *headView;
@end

static NSString *attentionidentfid2 = @"attentionidentfid2";

@implementation attentionVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.tableHeaderView = self.headView;
    [self layoutUI];
    [self loaddata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters


-(void)layoutUI
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-44);
    }];
}

-(void)loaddata
{
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"agencyId":agencyId,@"companyId":self.companyId};
    [self.dataSource removeAllObjects];
    NSString *url = [BASEURL stringByAppendingString:POST_GUANZHIFENSI];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[focusModel2 class] json:responseObj[@"data"][@"list"]]];
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
        _table = [[UITableView alloc] init];
        _table.dataSource = self;
        _table.delegate = self;
        _table.emptyDataSetDelegate = self;
        _table.emptyDataSetSource = self;
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

-(attentionheadView *)headView
{
    if(!_headView)
    {
        _headView = [[attentionheadView alloc] init];
        _headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 36);
        _headView.titleLab.text = @"我的粉丝";
    }
    return _headView;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    attentionCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionidentfid2];
    cell = [[attentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attentionidentfid2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata2:self.dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    focusModel2 *model = self.dataSource[indexPath.row];
    attentiondetailsVC *vc = [attentiondetailsVC new];
    vc.isRead = @"0";
    vc.companyId = [NSString stringWithFormat:@"%ld",(long)model.companyId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 协议方法

//关注
-(void)myTabVClick0:(UITableViewCell *)cell
{
    NSIndexPath *index = [_table indexPathForCell:cell];
    focusModel2 *model = self.dataSource[index.row];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *relId = [NSString stringWithFormat:@"%ld",(long)model.companyId];
    NSString *type = @"0";
    NSDictionary *para = @{@"agencysId":agencysId,@"relId":relId,@"type":type};
    NSString *url = [BASEURL stringByAppendingString:GET_GUANZHU];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self loaddata];
            [[PublicTool defaultTool] publicToolsHUDStr:@"关注成功" controller:self sleep:1.4];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

//取消关注
-(void)myTabVClick2:(UITableViewCell *)cell
{
    NSIndexPath *index = [_table indexPathForCell:cell];
    focusModel2 *model = self.dataSource[index.row];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *attentionId = [NSString stringWithFormat:@"%ld",model.attentionId];
    NSDictionary *para = @{@"agencysId":agencysId,@"attentionId":attentionId};
    NSString *url = [BASEURL stringByAppendingString:GET_QUXIAOGUANZHU];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self loaddata];
            [[PublicTool defaultTool] publicToolsHUDStr:@"取消关注成功" controller:self sleep:1.4];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)myTabVClick1:(UITableViewCell *)cell
{
    
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您还没有粉丝！";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
@end
