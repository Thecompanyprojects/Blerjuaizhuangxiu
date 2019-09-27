//
//  localsiteVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localsiteVC.h"
#import "localsiteModel.h"
#import "localsiteCell.h"
#import <SDAutoLayout.h>
#import "ConstructionDiaryTwoController.h"
#import "MainMaterialDiaryController.h"

@interface localsiteVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
{
    int pagenum;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *localsiteidentfid = @"localsiteidentfid";

@implementation localsiteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"工地";
    self.dataSource = [NSMutableArray array];
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
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    
    NSString *cityId = self.cityId;
    NSString *countyId = self.countyId;

    NSString *page = @"1";
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_gongdi];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.dataSource removeAllObjects];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localsiteModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table.mj_header endRefreshing];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    pagenum++;
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    NSString *cityId = self.cityId;
    NSString *countyId = self.countyId;
  
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_gongdi];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localsiteModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table.mj_footer endRefreshing];
        [self.table reloadData];
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
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    localsiteCell *cell = [tableView dequeueReusableCellWithIdentifier:localsiteidentfid];
    cell = [[localsiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localsiteidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *url = [BASEURL stringByAppendingString:Local_siteadd1];
    localsiteModel *model = self.dataSource[indexPath.row];
    NSString *likeNum = @"0";
    NSString *scanCount = @"1";
    NSString *constructionId = model.constructionId;
    NSDictionary *para = @{@"likeNum":likeNum,@"scanCount":scanCount,@"constructionId":constructionId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
           // [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self sleep:1.5];
            [self loadNewData];
         
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
    
    if ([model.constructionType isEqualToString:@"0"]) {
        //施工日志
        ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
        constructionVC.consID = [model.constructionId integerValue];
        constructionVC.companyId = model.companyId;

        [self.navigationController pushViewController:constructionVC animated:YES];
    }
    else
    {
        //主材日志
        MainMaterialDiaryController *mainDiaryVC = [[MainMaterialDiaryController alloc] init];
        mainDiaryVC.consID = [model.constructionId integerValue];
     
        mainDiaryVC.companyId = model.companyId;
        [self.navigationController pushViewController:mainDiaryVC animated:YES];
    }
}

//Local_siteadd1
-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    localsiteModel *model = self.dataSource[index.row];
    if (model.iszan) {
        
    }
    else
    {
        NSString *url = [BASEURL stringByAppendingString:Local_siteadd1];
        NSString *likeNum = @"1";
        NSString *scanCount = @"0";
        NSString *constructionId = model.constructionId;
        NSDictionary *para = @{@"likeNum":likeNum,@"scanCount":scanCount,@"constructionId":constructionId};
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self sleep:1.5];
                model.iszan = YES;
                NSInteger liken = [model.likeNumber integerValue];
                liken = liken +1;
                model.likeNumber = [NSString stringWithFormat:@"%ld",liken];
                [self.table reloadData];
            }
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}
@end
