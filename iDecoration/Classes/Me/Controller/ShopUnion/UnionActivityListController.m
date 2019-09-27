//
//  UnionActivityListController.m
//  iDecoration
//
//  Created by sty on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UnionActivityListController.h"
#import "ShopUnionListCommonCell.h"
#import "UnionActivityListCell.h"

#import "TZImagePickerController.h"
#import "CreatActivityController.h"


#import "NSObject+CompressImage.h"
#import "DesignCaseListModel.h"

#import "UnionActivityListModel.h"
#import "ActivityManageController.h"

#import "ZCHCalculatorPayController.h"
#import "SetwWatermarkController.h"
#import "ZCHPublicWebViewController.h"
#import "CreatActivityController.h"
#import "SSPopup.h"


@interface UnionActivityListController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SSPopupDelegate,UIAlertViewDelegate>{
    NSInteger reviewTag;//审核
    NSInteger topTag;//置顶
    NSInteger cancleTopTag;//取消置顶
    NSInteger deleteTag;//删除活动
    
    BOOL topOrCreat;//置顶活动还是创建活动。no：创建活动。yes：置顶活动
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *bottomAddBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyLogo;
@property (nonatomic, assign) NSInteger calVipTag;//0:公司未开通计算器会员  1:开通
@property (nonatomic, assign) NSInteger meCalVipTag;//0:该人员未开通个人计算器会员  1:开通


@end

@implementation UnionActivityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.unionName;
//    self.isFManage = YES;
    self.dataArray = [NSMutableArray array];
//    [self requestActivityListInfo];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.bottomAddBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestActivityListInfo) name:@"refreshActivityList" object:nil];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self addSuspendedButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestActivityListInfo];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}


-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = INSTRCTIONHTML;
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    else{
        return 20;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }
    else{
        return 100;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        return [[UITableViewHeaderFooterView alloc]init];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ShopUnionListCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopUnionListCommonCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.UnionlogoImgV sd_setImageWithURL:[NSURL URLWithString:self.unionLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        cell.UnionnameL.text = self.unionName;
//        cell.UnionNumL.text = self.unionNumber;
        NSString *str = [NSString stringWithFormat:@"联盟编号:%@",self.unionNumber];
        cell.UnionNumL.text = str;
        return cell;
    }
    else{
        UnionActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnionActivityListCellFirst"];
        if (!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"UnionActivityListCell" owner:self options:nil][0];
        }
        [cell configData:self.dataArray[indexPath.row] isLeader:self.isLeader];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        ActivityManageController *vc = [[ActivityManageController alloc]init];
        UnionActivityListModel *model = self.dataArray[indexPath.row];
        vc.designsId = model.designsId;
        vc.activityId = model.activityId;
        vc.unionId = self.unionId;
        
        vc.readNum = model.readNum;
        vc.shareNumber = model.shareNumber;
        vc.personNum = model.personNum;
        vc.collectionNum = model.collectionNum;
        vc.designTitle = model.designTitle;
        vc.designSubTitle = model.designSubTitle;
        vc.coverMap = model.coverMap;

        vc.agencysId = model.agencysId;

        
        vc.startTime = model.startTime;
        vc.companyLandLine = model.companyLandLine;
        vc.companyPhone = model.companyPhone;
        vc.companyID = [NSString stringWithFormat:@"%ld", self.companyId];
        vc.calVipTag = self.calVipTag;
        vc.meCalVipTag = self.meCalVipTag;
        
        vc.companyName = self.companyName;
        vc.companLogo = self.companyLogo;
        if (model.activityPlace.integerValue == 1) { // 线上活动
            vc.activityAddress = @"线上活动";
        } else {
            vc.activityAddress = model.activityAddress;
        }
        vc.isStop = model.isStop;
        vc.musicStyle = model.musicPlay;
        
        vc.musicStyle = model.musicPlay;
        __weak typeof(self) weakSelf = self;
        vc.manageBlock = ^(NSInteger n) {
            if (n==1) {
                weakSelf.calVipTag=1;
            }
            if (n==2) {
                weakSelf.meCalVipTag=1;
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 这里是开启滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.活动置顶的权限：总经理或者经理能置顶所有的活动 2.活动取消置顶的权限：同上 3.活动删除的权限：盟主能删除所有活动 
    
//3.活动删除的权限：盟主能删除所有活动 
//
    if (self.isZManage||self.isFManage||self.isLeader) {
        return YES;
    }
    else{
       return NO;
    }
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//    __weak typeof(self) weakSelf = self;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除该活动？"
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认置顶该活动？"
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否取消置顶该活动？"
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
    
    //1.活动置顶的权限：总经理或者经理能置顶所有的活动 2.活动取消置顶的权限：同上 3.活动删除的权限：盟主能删除所有活动 
    UnionActivityListModel *model = self.dataArray[indexPath.row];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    if (self.isZManage||self.isFManage) {
        if (self.isLeader) {
            //
            /*
            if (model.topId) {
                //已置顶
                return [NSArray arrayWithObjects:cancelTopAction, deleteAction, nil];
            }
            else{
                return [NSArray arrayWithObjects:TopAction, deleteAction, nil];
            }
             */
            
            return [NSArray arrayWithObjects:deleteAction, nil];
        }
        else{
            /*
            if (model.topId) {
                //已置顶
                return [NSArray arrayWithObjects:cancelTopAction, nil];
            }
            else{
                return [NSArray arrayWithObjects:TopAction, nil];
            }
             */
            return nil;
        }
    }
    else{
        if (self.isLeader) {
            return [NSArray arrayWithObjects:deleteAction, nil];
        }
        else{
            return nil;
        }
    }
    
    
    
}

-(void)creatActivity{
    
    //先查询公司列表
    topOrCreat = NO;
    [self requestCompanyList];
    
    
    
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
            //先查询公司列表
            topOrCreat = YES;
            [self requestCompanyList];
        }
    }
    if (alertView.tag==500) {
        if (buttonIndex==1) {
            [self activityCancelToTop];
        }
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshActivityList" object:nil];
}

#pragma mark - 查询当前人员在联盟的公司信息

-(void)requestCompanyList{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"unionCompany/getUnionCompanayListByAgencysId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),
                               @"unionId":@(self.unionId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *arr = responseObj[@"companyList"];
                if (arr.count>0) {
                    NSMutableArray *temArray = [NSMutableArray array];
                    for (NSDictionary *dict in arr) {
                        NSString *companyName = [dict objectForKey:@"companyName"];
                        [temArray addObject:companyName];
                    }
                   
                    SSPopup* selection=[[SSPopup alloc]init];
                    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                    
                    selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                    selection.SSPopupDelegate=self;
                    [self.view addSubview:selection];
                    
                    
                    NSArray *QArray = [temArray copy];
                    
                    if (!topOrCreat) {
                        //创建活动
                        [selection CreateTableview:QArray withTitle:@"请选择活动所属公司" setCompletionBlock:^(int tag) {
                            YSNLog(@"%d",tag);
                            
                            NSDictionary *dict = arr[tag];
                            self.companyId = [[dict objectForKey:@"companyId"]integerValue];
                            
                            NSString *companyName = [dict objectForKey:@"companyName"];
                            NSString *companyLogo = [dict objectForKey:@"companyLogo"];
                            
                            
                            
                            NSInteger companyId = [[dict objectForKey:@"companyId"]integerValue];
                            CreatActivityController *vc = [[CreatActivityController alloc] init];
                            vc.isFistr = YES;
                            vc.companyId = companyId;
                            vc.unionId = _unionId;
                            vc.companyName = companyName;
                            vc.companyLogo = companyLogo;
                            [self.navigationController pushViewController:vc animated:YES];
                            
//                            YSNLog(@"%d",tag);
//
//                            NSDictionary *dict = arr[tag];
//                            self.companyId = [[dict objectForKey:@"companyId"]integerValue];
//
//                            NSString *companyName = [dict objectForKey:@"companyName"];
//                            NSString *companyLogo = [dict objectForKey:@"companyLogo"];
//                            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
//
//                            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
////                            NSDictionary *dict = arr[tag];
                            
                              //  [self.navigationController pushViewController:vc animated:YES];
                          //  }];
                            
                           // [self presentViewController:imagePickerVc animated:YES completion:nil];
                            
                            
                            
                        }
                         ];
                    }
                    else{
                        //置顶活动
                        
                        [selection CreateTableview:QArray withTitle:@"请选择置顶公司" setCompletionBlock:^(int tag) {
                            YSNLog(@"%d",tag);
                            
                            NSDictionary *dict = arr[tag];
                            self.companyId = [[dict objectForKey:@"companyId"]integerValue];
                            
                            [self activityToTop];
                        }
                         ];
                    }
                    
                    
                }
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



#pragma mark - 审核活动

-(void)reviewActivity:(NSInteger)tag{
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/upStatus.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    UnionActivityListModel *model = self.dataArray[reviewTag];
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
                [self requestActivityListInfo];
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

#pragma mark - 查询活动列表

-(void)requestActivityListInfo{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/getListByUnionId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"unionId":@(self.unionId),
                               @"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSDictionary *dict = responseObj[@"data"];
                NSArray *array = [dict objectForKey:@"activityList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[UnionActivityListModel class] json:array];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                [self.tableView reloadData];
                
                NSDictionary *companyDict = [dict objectForKey:@"company"];
                self.companyLogo = companyDict[@"companyLogo"];
                self.companyName = companyDict[@"companyName"];
                self.companyId = [companyDict[@"companyId"] integerValue];
                self.calVipTag = [companyDict[@"calVip"] integerValue];
                self.meCalVipTag = [responseObj[@"vipFlag"] longValue];
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无活动" controller:self sleep:1.5];
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

#pragma mark - 活动置顶
-(void)activityToTop{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"activityTop/save.do"];
    
    UnionActivityListModel *model = self.dataArray[topTag];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    NSDictionary *paramDic = @{@"companyId":@(self.companyId), @"activityId":model.activityId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"置顶成功" controller:self sleep:1.5];
                [self requestActivityListInfo];
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
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    UnionActivityListModel *model = self.dataArray[cancleTopTag];
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
                [self requestActivityListInfo];
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

#pragma mark - 删除活动
-(void)deleteActivity{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    UnionActivityListModel *model = self.dataArray[deleteTag];
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
                [self requestActivityListInfo];
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
#pragma mark - 图片上传
- (void)uploadImgWith:(NSArray *)imgArray{
    //    NSLog(@"名字:%@ 和身份证号:%@", name, idNum);
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < imgArray.count; i++) {
            
            UIImage *image = imgArray[i];
            //            NSData *imageData = UIImageJPEGRepresentation(image, PHOTO_COMPRESS);
            NSData *imageData = [NSObject imageData:image];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
            
            DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
            model.imgUrl = [dict objectForKey:@"imgUrl"];
            model.detailsId = 0;
            model.content = @"";
            model.htmlContent = @"";
            [dataArray addObject:model];
            
        }
        
        
        CreatActivityController *designVC = [[CreatActivityController alloc]init];
        designVC.unionId = self.unionId;
        designVC.consID = self.unionId;
        designVC.isPower = YES;
        designVC.dataArray = dataArray;
        
        DesignCaseListModel *temModel = dataArray.firstObject;
        designVC.coverImgUrl = temModel.imgUrl;
        designVC.isFistr = YES;
        designVC.companyLogo = self.unionLogo;
        designVC.companyId = self.companyId;
        
        designVC.isComplate = NO;
        designVC.reloadBlock = ^{
            //刷新列表信息
            [self requestActivityListInfo];
        };
        [self.navigationController pushViewController:designVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

#pragma mark - lazy

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64-40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = kBackgroundColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ShopUnionListCommonCell" bundle:nil] forCellReuseIdentifier:@"ShopUnionListCommonCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"UnionActivityListCell" bundle:nil] forCellReuseIdentifier:@"UnionActivityListCell"];
        
        //        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.separatorColor = kSepLineColor;
    }
    return _tableView;
}

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40, kSCREEN_WIDTH, 40)];
        _bottomV.backgroundColor = kBackgroundColor;
    }
    return _bottomV;
}

-(UIButton *)bottomAddBtn{
    if (!_bottomAddBtn) {
        _bottomAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomAddBtn.frame = CGRectMake(kSCREEN_WIDTH/2-60, 0, 120, 40);
        [_bottomAddBtn setTitle:@"创建活动" forState:UIControlStateNormal];
        [_bottomAddBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        _bottomAddBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        [_bottomAddBtn addTarget:self action:@selector(creatActivity) forControlEvents:UIControlEventTouchUpInside];
        [_bottomAddBtn setImage:[UIImage imageNamed:@"greenAddBtn"] forState:UIControlStateNormal];
    }
    return _bottomAddBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
