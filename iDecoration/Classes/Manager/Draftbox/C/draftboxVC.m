//
//  draftboxVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "draftboxVC.h"
#import "draftboxCell.h"
#import <SDAutoLayout.h>
#import "draftboxModel.h"
#import "GKCover.h"
#import "EditNewsActivityController.h"
#import "VoteOptionModel.h"
#import "DesignCaseListModel.h"
#import "coverView.h"
#import "EditMyBeatArtController.h"

@interface draftboxVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
{
    int pageint;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) coverView *cover;
@property (nonatomic,copy) NSString *draftId;
@end

static NSString *draftidentfid = @"draftidentfid";

@implementation draftboxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的草稿箱";
    self.draftId = [NSString new];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    pageint = 1;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load

-(void)loadNewData
{
    pageint = 1;
    NSString *page = [NSString stringWithFormat:@"%d",pageint];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"page":page,@"agencysId":agencysId};
    NSString *url = [BASEURL stringByAppendingString:POST_CAOGAO];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.dataSource removeAllObjects];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[draftboxModel class] json:responseObj[@"data"][@"list"]]];
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
    NSString *page = [NSString stringWithFormat:@"%d",pageint];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"page":page,@"agencysId":agencysId};
    NSString *url = [BASEURL stringByAppendingString:POST_CAOGAO];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[draftboxModel class] json:responseObj[@"data"][@"list"]]];
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


-(coverView *)cover
{
    if(!_cover)
    {
        _cover = [[coverView alloc] init];
        [_cover.leftBtn addTarget:self action:@selector(leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_cover.rightBtn addTarget:self action:@selector(rightbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}




#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 10;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    draftboxCell *cell = [tableView dequeueReusableCellWithIdentifier:draftidentfid];
    cell = [[draftboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:draftidentfid];
    cell.delegate = self;
    [cell setdata:self.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}

// 1.只要实现这个方法,就会拥有左滑删除功能 2.点击"左滑出现的按钮"会调用这个方法

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    draftboxModel *model = self.dataSource[indexPath.row];
    NSString *draftId = model.draftId;
    NSDictionary *para = @{@"draftId":draftId};
    NSString *url = [BASEURL stringByAppendingString:POST_DELCAOGAO];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self loadNewData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [_table indexPathForCell:cell];
    draftboxModel *model = self.dataSource[index.row];
    self.draftId = model.draftId;
    self.cover.backgroundColor = [UIColor whiteColor];
    self.cover.gk_size = CGSizeMake(KScreenW, 180);
    [GKCover translucentCoverFrom:self.view content:self.cover animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    draftboxModel *model = self.dataSource[indexPath.row];
    NSString *str = model.draftContent;
    
    EditMyBeatArtController *vc = [EditMyBeatArtController new];
    NSDictionary *dict = [self dictionaryWithJsonString:str];
    
    NSDictionary *design = [dict objectForKey:@"design"];
    NSArray *details = [dict objectForKey:@"details"];
    NSDictionary *vote = [dict objectForKey:@"vote"];
    
    NSArray *dataArr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:details];
    [vc.orialArray addObjectsFromArray:dataArr];
    [vc.dataArray addObjectsFromArray:dataArr];

    vc.coverTitle = [design objectForKey:@"designTitle"];
    vc.coverTitleTwo = [design objectForKey:@"designSubtitle"];
    vc.coverImgUrl = [design objectForKey:@"coverMap"];
    vc.musicStyle = [[design objectForKey:@"musicPlay"]integerValue];
    vc.endTime = [design objectForKey:@"voteEndTime"];
    vc.musicName = [design objectForKey:@"musicName"] ;
    vc.musicUrl = [design objectForKey:@"musicUrl"];
    vc.coverImgStr = [design objectForKey:@"picUrl"] ;
    vc.nameStr = [design objectForKey:@"picTitle"];
    vc.linkUrl = [design objectForKey:@"picHref"];
    vc.voteType = [NSString stringWithFormat:@"%@",[vote objectForKey:@"voteType"]];
    vc.voteDescribe = [vote objectForKey:@"voteDescribe"];
    vc.endTime = [vote objectForKey:@"voteEndTime"];

    vc.isFistr = YES;
    vc.isHaveSignUp = YES;
    
    vc.isCaogao = YES;
    vc.draftId = model.draftId;
    vc.designId = [model.designsId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 推送方法

-(void)leftbtnclick
{
    NSString *type = @"2";
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    
    NSDictionary *para = @{@"draftId":self.draftId,@"type":type,@"agencysId":agencysId};
    NSString *url = [BASEURL stringByAppendingString:POST_PUSHCAOGAO];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self sleep:1.5];
            [self loadNewData];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1001) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1003) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"没加入公司" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)rightbtnclick
{

    NSString *type = @"3";
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
   
    NSDictionary *para = @{@"draftId":self.draftId,@"type":type,@"agencysId":agencysId};
    NSString *url = [BASEURL stringByAppendingString:POST_PUSHCAOGAO];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self sleep:1.5];
            [self loadNewData];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1001) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1003) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"没加入公司" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
