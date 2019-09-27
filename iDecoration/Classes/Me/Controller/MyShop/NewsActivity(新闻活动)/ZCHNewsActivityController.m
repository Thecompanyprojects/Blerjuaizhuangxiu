//
//  ZCHNewsActivityController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/11/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHNewsActivityController.h"
#import "UnionActivityListCell.h"
#import "BeautifulArtListModel.h"
#import "EditNewsActivityController.h"
#import "SetwWatermarkController.h"
#import "NewsActivityShowController.h"
#import "NewsActivityManageController.h"
#import "ActivityShowController.h"
#import "TZImagePickerController.h"
#import "VoteOptionModel.h"
#import "SSPopup.h"
#import "AdvertisingVC.h"


static NSString *reuseIdentifier = @"UnionActivityListCellFirst";
static NSString *reuseIdentifierTwo = @"UnionActivityListCellTwo";
@interface ZCHNewsActivityController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    NSInteger reviewTag;//审核的tag
    NSInteger deleteTag;//删除的tag
    NSInteger topTag;//置顶的tag
    NSInteger cancleTopTag;//取消置顶的tag
    NSInteger tongchengTag;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger calVipTag;//0:公司未开通计算器会员  1:开通
@property (nonatomic, assign) NSInteger meCalVipTag;//0:该人员未开通个人计算器会员  1:开通
@end

@implementation ZCHNewsActivityController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"新闻活动";
    self.dataArray = [NSMutableArray array];
    
    //公司号码通
    self.calVipTag = [self.model.calVip integerValue];
    [self setUpUI];
    [self getData];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"广告位" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData) name:@"refreshNewsActivityList" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
}

- (void)setUpUI {
    
    UIButton *createNewsBtn = [[UIButton alloc] init];
    if (BLEJHeight > 736) {
        
        createNewsBtn.frame = CGRectMake(0, BLEJHeight - 59, BLEJWidth, 59);
        [createNewsBtn setBackgroundColor:kBackgroundColor];
        [createNewsBtn addTarget:self action:@selector(didClickCreateNewsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:createNewsBtn];
        
        UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 50, 10, 24, 24)];
        addImage.image = [UIImage imageNamed:@"greenAddBtn"];
        [createNewsBtn addSubview:addImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(addImage.right + 10, 0, 100, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kMainThemeColor;
        label.text = @"创建新闻";
        label.font = [UIFont systemFontOfSize:16];
        [createNewsBtn addSubview:label];
    } else {
        
        createNewsBtn.frame = CGRectMake(0, BLEJHeight - 44, BLEJWidth, 44);
        [createNewsBtn setBackgroundColor:kBackgroundColor];
        [createNewsBtn addTarget:self action:@selector(didClickCreateNewsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:createNewsBtn];
        
        UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 50, 10, 24, 24)];
        addImage.image = [UIImage imageNamed:@"greenAddBtn"];
        [createNewsBtn addSubview:addImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(addImage.right + 10, 0, 100, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kMainThemeColor;
        label.text = @"创建新闻";
        label.font = [UIFont systemFontOfSize:16];
        [createNewsBtn addSubview:label];
    }
    
    CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom + createNewsBtn.height);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
    self.tableView.backgroundColor = White_Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [NSMutableArray array];
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
        BOOL isLeader = NO;
        NSInteger agencysJob = [self.model.agencysJob integerValue];
        if (agencysJob==1002||agencysJob==1003||agencysJob==1027) {
            isLeader = YES;
        }
        else{
            isLeader = NO;
        }
        [cell configData:self.dataArray[indexPath.row] isLeader:isLeader];
        cell.stateBtn.tag = indexPath.row;
        
        cell.stateBtnBlock = ^(NSInteger tag){
            reviewTag = tag;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"活动是否可以通过？"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"通过",@"不通过", nil];
            //            deleteCaseIndex = path.row;
            alertView.tag = 200;
            [alertView show];
        };
        
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BeautifulArtListModel *model = self.dataArray[indexPath.row];
    if (model.startTime&&model.startTime.length>2){
        if (model.type==1) {
            //联盟活动
            [self requestUnionDetailWith:model];
        }
        else{
            //新闻活动
            NewsActivityManageController *vc = [[NewsActivityManageController alloc]init];
            vc.designsId = model.designsId;
            vc.activityId = model.activityId;
            vc.jobTag = [self.model.agencysJob integerValue];
            
            vc.readNum = model.readNum;
            vc.shareNumber = model.shareNumber;
            vc.personNum = model.personNum;
            vc.collectionNum = model.collectionNum;
            vc.designTitle = model.designTitle;
            vc.designSubTitle = model.designSubTitle;
            vc.coverMap = model.coverMap;
            
            vc.agencysId = model.agencysId;
            
            
            vc.activityTime = model.startTime;
            vc.companyLandLine = self.model.companyLandline;
            vc.companyPhone = self.model.companyPhone;
            vc.companyID = self.model.companyId;
            
            //vip
            vc.calVipTag = self.calVipTag;
            vc.meCalVipTag = self.meCalVipTag;
            
            vc.companyName = self.model.companyName;
            vc.companyLogo = self.model.companyLogo;
            if (model.activityPlace.integerValue == 1) { // 线上活动
                vc.activityAddress = @"线上活动";
            } else {
                vc.activityAddress = model.activityAddress;
            }
            vc.isStop = model.isStop;
            vc.musicStyle = model.musicPlay;
            __weak typeof(self) weakSelf = self;
            vc.newsManageShowBlock = ^(NSInteger n) {
                if (n==1) {
                    weakSelf.calVipTag=1;
                    if (self.ZCHNewsActivityVipBlock) {
                        self.ZCHNewsActivityVipBlock();
                    }
                }
                if (n==2) {
                    weakSelf.meCalVipTag=1;
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
    else{
        //美文
        
        NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
        vc.designsId = [model.designsId integerValue];
        vc.activityId = model.activityId;
        vc.activityType = 2;
        vc.origin = @"2";
        vc.designTitle = model.designTitle;
        vc.designSubTitle = model.designSubTitle;
        vc.coverMap = model.coverMap;
        vc.agencysId = model.agencysId;
        vc.companyName = self.model.companyName;
        vc.companyLogo = self.model.companyLogo;
        
        
        vc.companyId = self.model.companyId;
        vc.calVipTag = self.calVipTag;
        vc.meCalVipTag = self.meCalVipTag;
        vc.jobTag = [self.model.agencysJob integerValue];
        
        vc.activityTime = model.startTime;
        vc.activityAddress = model.activityAddress;
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


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

#pragma mark - 这里是开启滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.活动置顶的权限：总经理或者经理能置顶所有的活动 2.活动取消置顶的权限：同上 3.活动删除的权限：盟主能删除所有活动 
    
    //3.活动删除的权限：经理总经理能删除只能删除新闻活动和美文（不能删联盟活动）
    //
    NSInteger jobTag = [self.model.agencysJob integerValue];
    if (jobTag==1003||jobTag==1027||self.implement||jobTag==1002) {
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        ZCHCooperateListModel *model = self.dataArr[indexPath.row];
//        [self fireCooperateWithModel:model];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  __weak typeof(self) weakSelf = self;
    NSString *tipStr;
    BeautifulArtListModel *model = self.dataArray[indexPath.row];
    if (model.startTime&&model.startTime.length>2){
        tipStr = @"活动";
    }
    else{
        tipStr = @"美文";
    }
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //    __weak typeof(self) weakSelf = self;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否删除该%@",tipStr]
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        //                                                           delegate:self
        deleteTag = indexPath.row;
        alertView.tag = 300;
        [alertView show];
    }];
    
    
    
    UITableViewRowAction *TopAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //这个按钮需要处理的代码块
        //        [weakSelf cancelTopConstructionWithIndex:indexPath];
        //        changeTag = indexPath.row;
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否置顶该%@",tipStr]
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        //        deleteCaseIndex = path.row;
        topTag = indexPath.row;
        alertView.tag = 400;
        [alertView show];
    }];
    TopAction.backgroundColor = [UIColor lightGrayColor];
    //    UIContextualAction
    UITableViewRowAction *cancelTopAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //这个按钮需要处理的代码块
        //        [weakSelf cancelTopConstructionWithIndex:indexPath];
        //        changeTag = indexPath.row;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否取消置顶该%@",tipStr]
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        //        deleteCaseIndex = path.row;
        cancleTopTag = indexPath.row;
        alertView.tag = 500;
        [alertView show];
    }];
    cancelTopAction.backgroundColor = [UIColor lightGrayColor];

    
    //活动状态（0：报名中，1：待审核，3：活动结束，4：活动进行中，5：审核不通过，6：停止报名，7：报名人数达到上限）
    //1和5不能置顶
    NSInteger jobTag = [self.model.agencysJob integerValue];
    NSInteger activityStatus = [model.activityStatus integerValue];
    if (self.implement||jobTag==1003||jobTag==1027||jobTag==1002) {
        //经理总经理和店铺经理可以删除（联盟活动不能删）,置顶（1和5不能置顶）和取消置顶(1和5不能取消置顶)
        
        if (model.type==1) {
            //联盟活动不能删
            
            if (activityStatus==1||activityStatus==5) {
                return nil;
            }
            else{
                if (model.topId) {
                    //已置顶
                    return [NSArray arrayWithObjects:cancelTopAction, nil];
                }
                else{
                    return [NSArray arrayWithObjects:TopAction, nil];
                }
            }
        }
        else{
            
            if (activityStatus==1||activityStatus==5) {
                return [NSArray arrayWithObjects:deleteAction, nil];
            }
            else{
                if (model.topId) {
                    
                    //已置顶
                    return [NSArray arrayWithObjects:cancelTopAction, deleteAction,nil];

                }
                else{
                     return [NSArray arrayWithObjects:TopAction, deleteAction, nil];
                    
                }
            }
            
        }
        
        
        
    }
    else{
        return nil;
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==200) {
        if (buttonIndex==1) {
            [self reviewActivity:1];
        }
        if (buttonIndex==2) {
            [self reviewActivity:2];
        }
    }
    
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            [self deleteActivity];
        }
    }
    
    if (alertView.tag==400) {
        if (buttonIndex==1) {
            //置顶
            [self activityToTop];
        }
    }
    if (alertView.tag==500) {
        if (buttonIndex==1) {
            [self activityCancelToTop];
        }
    }
   
    
}

#pragma mark - 审核活动

-(void)reviewActivity:(NSInteger)tag{
    //    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/upStatus.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    BeautifulArtListModel *model = self.dataArray[reviewTag];
    NSDictionary *paramDic = @{@"activityId":model.activityId,
                               @"status":@(tag)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"审核成功" controller:self sleep:1.5];
                [self getData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"审核失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 活动置顶
-(void)activityToTop{
    //UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"activityTop/save.do"];
    
    BeautifulArtListModel *model = self.dataArray[topTag];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *activityID;
    if (model.startTime&&model.startTime.length>2) {
        activityID = model.activityId;
    }
    else{
        activityID = @"0";
    }
    
    NSDictionary *paramDic = @{@"companyId":self.model.companyId, @"activityId":activityID,
                               @"designsId":model.designsId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"置顶成功" controller:self sleep:1.5];
                [self getData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"美文置顶达到上限" controller:self sleep:1.5];
            }
            
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"该活动不能置顶" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 活动取消置顶
-(void)activityCancelToTop{
   // UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    BeautifulArtListModel *model = self.dataArray[cancleTopTag];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"activityTop/del.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"topId":@(model.topId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"取消置顶成功" controller:self sleep:1.5];
                [self getData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

// 创建新闻
- (void)didClickCreateNewsBtn:(UIButton *)btn {

    EditNewsActivityController *vc = [[EditNewsActivityController alloc] init];
    vc.isFistr = YES;
    vc.companyId = [self.model.companyId intValue];
    vc.jobTag = self.model.agencysJob.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除美文或活动
-(void)deleteActivity{
   // UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    BeautifulArtListModel *model = self.dataArray[deleteTag];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/delete.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":model.designsId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                [self getData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"活动结束一个月后才能删除" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
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
                
                vc.companyLandLine = self.model.companyLandline;
                vc.companyPhone = self.model.companyPhone;
                vc.companyId = self.model.companyId;
                
                //会员标识可以不传
                vc.calVipTag = self.calVipTag;
                vc.meCalVipTag = self.meCalVipTag;
                
                vc.companyName = self.model.companyName;
                vc.companyLogo = self.model.companyLogo;
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
                            @"companyId":self.model.companyId?:@"",
                            @"agencysId":@(agencyid),@"type":@"0"
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
                self.meCalVipTag = [responseObj[@"vipFlag"] integerValue];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                [self.tableView reloadData];
            } else if (statusCode == 1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无新闻" controller:self sleep:1.5];
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



#pragma mark - 广告位

-(void)rightBtnClick
{
    AdvertisingVC *vc = [AdvertisingVC new];
    vc.relId = self.model.companyId;
    vc.type = @"20";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
