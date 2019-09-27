//
//  ZCHNewsInforController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHNewsInforController.h"
#import "UnionActivityListCell.h"
#import "BeautifulArtListModel.h"
#import "NewsActivityShowController.h"
#import "ActivityShowController.h"

static NSString *reuseIdentifier = @"UnionActivityListCellFirst";
static NSString *reuseIdentifierTwo = @"UnionActivityListCellTwo";
@interface ZCHNewsInforController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ZCHNewsInforController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"新闻资讯";
    self.dataArray = [NSMutableArray array];
    [self setUpUI];
    [self getData];
}

- (void)setUpUI {
    
    CGFloat naviBottom = kSCREEN_HEIGHT - self.navigationController.navigationBar.bottom;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
    self.tableView.backgroundColor = White_Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BeautifulArtListModel *model = self.dataArray[indexPath.row];
    if (model.startTime && model.startTime.length > 2) {
        //活动
        UnionActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"UnionActivityListCell" owner:self options:nil][0];
        }
        [cell configData:self.dataArray[indexPath.row] isLeader:YES];
        cell.stateBtn.tag = indexPath.row;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 100 - 1, kSCREEN_WIDTH-10, 1)];
        lineV.backgroundColor = kSepLineColor;
        [cell addSubview:lineV];
        return cell;
    } else {
        //美文
        UnionActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTwo];
        if (!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"UnionActivityListCell" owner:self options:nil][1];
        }
        [cell configData:self.dataArray[indexPath.row] isLeader:YES];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 50 - 1, kSCREEN_WIDTH - 10, 1)];
        lineV.backgroundColor = kSepLineColor;
        [cell addSubview:lineV];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BeautifulArtListModel *model = self.dataArray[indexPath.row];
    if (model.startTime&&model.startTime.length > 2){
        
        if (model.type==1) {
            //联盟活动
            [self requestUnionDetailWith:model];
        }
        else{
            //新闻活动
            NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
            vc.designsId = [model.designsId integerValue];
            vc.activityType = 3;
            // 手机号  座机号
            vc.companyPhone = [self.companyDic objectForKey:@"companyPhone"];
            vc.companyLandLine = [self.companyDic objectForKey:@"companyLandline"];
            vc.origin = @"0";
            vc.companyLogo = [self.companyDic objectForKey:@"companyLogo"];
            vc.companyName = [self.companyDic objectForKey:@"companyName"];
            vc.companyId = [self.companyDic objectForKey:@"companyId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    } else {
        //美文
        NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
        vc.designsId = [model.designsId integerValue];
        vc.activityType = 2;
        // 手机号  座机号
        vc.companyPhone = [self.companyDic objectForKey:@"companyPhone"];
        vc.companyLandLine = [self.companyDic objectForKey:@"companyLandline"];
        vc.origin = @"0";
        vc.companyLogo = [self.companyDic objectForKey:@"companyLogo"];
        vc.companyName = [self.companyDic objectForKey:@"companyName"];
        vc.companyId = [self.companyDic objectForKey:@"companyId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BeautifulArtListModel *model = self.dataArray[indexPath.row];
    if (model.startTime && model.startTime.length > 2) {
        
        return 100;
    } else {
        
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}


#pragma mark - 查询联盟活动详情
-(void)requestUnionDetailWith:(BeautifulArtListModel *)model{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/getByDesignsId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":model.designsId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                NSArray *arr = responseObj[@"data"][@"design"];
                NSDictionary *dict = arr.firstObject;
                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                
                ActivityShowController *vc = [[ActivityShowController alloc]init];
                
                vc.designsId = model.designsId;
                vc.activityId = model.activityId;
                
                vc.designTitle = [dict objectForKey:@"designTitle"];
                vc.designSubTitle = [dict objectForKey:@"designSubtitle"];
                vc.coverMap = [dict objectForKey:@"coverMap"];
                
                
                vc.companyPhone = [self.companyDic objectForKey:@"companyPhone"];
                vc.companyLandLine = [self.companyDic objectForKey:@"companyLandline"];
                
                vc.companyLogo = [self.companyDic objectForKey:@"companyLogo"];
                vc.companyName = [self.companyDic objectForKey:@"companyName"];
                vc.companyId = [self.companyDic objectForKey:@"companyId"];
                
                //会员标识可以不传
//                vc.calVipTag = self.calVipTag;
//                vc.meCalVipTag = self.meCalVipTag;
                
                
                vc.activityAddress = [activityDict objectForKey:@"activityAddress"];
                vc.activityTime = [activityDict objectForKey:@"startTime"];
                vc.musicStyle = [[dict objectForKey:@"musicPlay"] integerValue];
                vc.order = [[dict objectForKey:@"order"] integerValue];
                vc.templateStr = [dict objectForKey:@"template"];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 获取数据
- (void)getData {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"designs/getDesignListByCompanyIdORAgencysId.do"];
    NSDictionary *param = @{
                            @"companyId" : self.companyId,
                            @"agencysId" : @(agencyid),
                            @"type" : @"1"
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode == 1000) {
                
                NSDictionary *dict = responseObj[@"data"];
                NSArray *array = [dict objectForKey:@"activityList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[BeautifulArtListModel class] json:array];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                [self.tableView reloadData];
            } else if (statusCode == 1002) {
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
            } else {
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
