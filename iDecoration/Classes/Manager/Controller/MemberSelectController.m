//
//  MemberSelectController.m
//  iDecoration
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MemberSelectController.h"
#import "MemberSelectModel.h"
#import "ShopDetailBottomCell.h"
#import "ConstructMemberAddController.h"

#import "MainMemberSelectModel.h"


@interface MemberSelectController ()<UITableViewDelegate,UITableViewDataSource,ShopDetailBottomCellDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MemberSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    [self creatUI];
    if (self.index == 1) {
        [self requestList];
    }
    if (self.index == 2) {
        [self getShopJobList];
    }
    
    
}

-(void)creatUI{
    self.title = @"职位选择";
    self.view.backgroundColor = White_Color;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailBottomCell"];
    MemberSelectModel *model = self.dataArray[indexPath.row];
    cell.delegate = self;
//    cell.addBtn.centerY = cell.contentView.centerY;
    cell.tag = indexPath.row;
    [cell configData:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ShopDetailBottomCellDelegate

-(void)addPeopleWith:(NSInteger)tag{
    if (self.index == 1) {
        [self judgeAddPowerWith:tag];
    }
    if (self.index == 2) {
        MainMemberSelectModel *model = self.dataArray[tag];
        ConstructMemberAddController *vc = [[ConstructMemberAddController alloc]init];
        NSInteger jobId = [model.cJobTypeId integerValue];
        // || 工人 jobId == 1025
        if (jobId == 1001) {
            // 业主
            vc.index = 1;
        }
        else{
            //普通员工
            vc.index = 2;
        }
        vc.jobId = jobId;
        vc.consID = self.consID;
        vc.participanId = model.cJobTypeId;
        vc.companyFlag = self.companyFlag;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 添加人员的操作权限

-(void)judgeAddPowerWith:(NSInteger)tag{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    MemberSelectModel *model = self.dataArray[tag];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/operatingAuthority.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"userId":@(user.agencyId),
                               @"nodeNumber":@(3002),
                               @"participanId":model.cJobTypeId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                {
                    
                    ConstructMemberAddController *vc = [[ConstructMemberAddController alloc]init];
                    NSInteger jobId = [model.cJobTypeClass integerValue];
                    if (jobId == 1001||jobId == 1025) {
                        //工人（1025），业主（1001）
                        vc.index = 1;
                    }
                    else{
                        //普通员工
                        vc.index = 2;
                    }
                    vc.consID = self.consID;
                    vc.fromIndex = 1;
                    vc.participanId = model.cJobTypeId;
                    
                    vc.jobId = jobId;
                    vc.groupid = self.groupid;
                    vc.huanxinID = model.huanXinId;
                    vc.companyFlag = self.companyFlag;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    
                    break;
                    
                case 10001:
                {
    
                    [[PublicTool defaultTool] publicToolsHUDStr:@"抱歉，你没有操作权限" controller:self sleep:1.5];
                    return;
                }
                    
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 获取公司职位列表

-(void)requestList{
    [self.dataArray removeAllObjects];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/queryAllJobTypeInform.do"];
    NSDictionary *paramDic = @{@"":@""
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                {
                    if ([responseObj[@"JobList"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = responseObj[@"JobList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[MemberSelectModel class] json:array];
                        [self.dataArray addObjectsFromArray:arr];
                        NSMutableArray *temArray = [NSMutableArray array];
                        for (MemberSelectModel *model in self.dataArray) {
                            if ([model.cJobTypeId integerValue]==1024||[model.cJobTypeId integerValue]==1025) {
                                [temArray addObject:model];
                            }
                        }
                        //                        [self.tableView reloadData];
                        [self.dataArray removeObjectsInArray:temArray];
                        YSNLog(@"%@",self.dataArray);
                        [self.tableView reloadData];
                    };
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 获取商家职位列表

-(void)getShopJobList{
    [self.dataArray removeAllObjects];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"jobType/getMerchantJobType.do"];
    NSDictionary *paramDic = @{@"":@""
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                {
                    if ([[responseObj[@"data"] objectForKey:@"jobList"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = [responseObj[@"data"] objectForKey:@"jobList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[MainMemberSelectModel class] json:array];
                        [self.dataArray addObjectsFromArray:arr];
                        MainMemberSelectModel *model = [[MainMemberSelectModel alloc]init];
                        model.cJobTypeId = @"1002";
                        model.cJobTYpeName = @"总经理";
                        
                        //                        [self.tableView reloadData];
                        [self.dataArray insertObject:model atIndex:0];
                        MainMemberSelectModel *modelOne = [[MainMemberSelectModel alloc]init];
                        modelOne.cJobTypeId = @"1001";
                        modelOne.cJobTYpeName = @"业主";
                        
                        //                        [self.tableView reloadData];
                        [self.dataArray insertObject:modelOne atIndex:0];
                        YSNLog(@"%@",self.dataArray);
                        [self.tableView reloadData];
                    };
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ShopDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"ShopDetailBottomCell"];
        //        _tableView.backgroundColor = Black_Color;
        //        [_tableView addHeaderWithTarget:self action:@selector(loadData)];
        //        [_tableView addFooterWithTarget:self action:@selector(upLoadData)];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
