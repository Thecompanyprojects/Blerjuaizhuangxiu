//
//  ShopUnionListController.m
//  iDecoration
//  联盟列表
//  Created by sty on 2017/10/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopUnionListController.h"
#import "ShopUnionListCommonCell.h"
#import "VIPExperienceShowViewController.h"
#import "ShopUnionListMiddleCell.h"
#import "CreatActivityController.h"
#import "YellowPageCompanyTableViewCell.h"
#import "YellowPageShopTableViewCell.h"
#import "UnionActivityListController.h"
#import "UnionAddBusinessController.h"
#import "CreatShopUnionController.h"
#import "ShopUnionListModel.h"
#import "MeViewController.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "SSPopup.h"
#import "TZImagePickerController.h"
#import "SetwWatermarkController.h"

@interface ShopUnionListController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SSPopupDelegate>{
    NSInteger deleteTag;
    NSInteger changeTag;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *bottomAddBtn;

@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation ShopUnionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.unionName;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.bottomAddBtn];
    
//    if (self.isLeader) {
        // 设置导航栏最右侧的按钮
        UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        editBtn.frame = CGRectMake(0, 0, 44, 44);
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.editBtn = editBtn;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
        
//    }
    if (self.isLeader) {
        self.editBtn.hidden = NO;
        
        self.bottomV.hidden = NO;
        self.tableView.frame =CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64-40);
    }
    else{
        self.editBtn.hidden = YES;
        self.bottomV.hidden = YES;
        self.tableView.frame =CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
    }
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
//    for (UIViewController *vc in self.navigationController.childViewControllers) {
//        if ([vc isKindOfClass:[MeViewController class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//        }
//    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return self.dataArray.count;
    }
    else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }
    else if (section==1) {
        return 8;
    }
    else{
        return 30;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 20;
    }
    else{
        return 0.1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }
    else if (indexPath.section==2) {
        return 86;
    }
    else{
       return 50;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = kBackgroundColor;
        UILabel *LogoName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH-15, 30)];
        LogoName.text = @"联盟成员";
        LogoName.textColor = COLOR_BLACK_CLASS_3;
        LogoName.font = NB_FONTSEIZ_NOR;
        LogoName.textAlignment = NSTextAlignmentLeft;
        [view addSubview:LogoName];
        
        UIButton *addbtn = [[UIButton alloc] init];
        [addbtn setImage:[UIImage imageNamed:@"jia1"] forState:normal];
        addbtn.frame = CGRectMake(kSCREEN_WIDTH-8-25, 0, 25, 25);
        [addbtn addTarget:self action:@selector(addbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addbtn];

        return view;
    }
    else{
        return [[UITableViewHeaderFooterView alloc]init];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ShopUnionListCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopUnionListCommonCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.UnionlogoImgV.image = [UIImage imageNamed:DefaultIcon];
        [cell.UnionlogoImgV sd_setImageWithURL:[NSURL URLWithString:self.unionLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        cell.UnionnameL.text = self.unionName;
        NSString *str = [NSString stringWithFormat:@"联盟编号:%@",self.unionNumber];
        cell.UnionNumL.text = str;
        cell.unionNumRightCont.constant = 75;
        
        UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        successBtn.frame = CGRectMake(kSCREEN_WIDTH-60-15,100-20-15,60,20);
        successBtn.backgroundColor = kBackgroundColor;
        [successBtn setTitle:@"退出联盟" forState:UIControlStateNormal];
        successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [successBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
        successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        successBtn.layer.masksToBounds = YES;
        successBtn.layer.cornerRadius = 5;
        [successBtn addTarget:self action:@selector(requestCompanyList) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:successBtn];
        if (self.isZManage||self.isFManage) {
            //是经理或总经理
            successBtn.hidden = NO;
        }
        else{
            successBtn.hidden = YES;
        }
        return cell;
    }
    else if (indexPath.section==1) {
        NSString *cellIdendifier = @"cellTemp";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier];;
        }
        cell.contentView.backgroundColor = White_Color;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"活动列表";
        return cell;
    }
    else{
        ShopUnionListMiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopUnionListMiddleCell"];
        [cell configData:self.dataArray[indexPath.row]];
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        UnionActivityListController *vc = [[UnionActivityListController alloc]init];
        vc.unionId = self.unionId;
        vc.unionLogo = self.unionLogo;
        vc.unionName = self.unionName;
        vc.unionNumber = self.unionNumber;
        vc.isLeader = self.isLeader;
        vc.isZManage = self.isZManage;
        vc.isFManage = self.isFManage;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2) {
        
        ShopUnionListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([model.appVip isEqualToString:@"1"]) {
            
            //公司的详情
            if ([model.companyType isEqualToString:@"1018"] ||
                [model.companyType isEqualToString:@"1064"] ||
                [model.companyType isEqualToString:@"1065"]) {
                CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
                company.companyName = model.companyName;
                company.companyID = model.companyId;
                company.hidesBottomBarWhenPushed = YES;
                company.origin = @"0";
                [self.navigationController pushViewController:company animated:YES];
            } else {
                //店铺的详情;
                ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
                shop.shopName = model.companyName;
                shop.shopID = model.companyId;
                model.displayNumber = [NSString stringWithFormat:@"%ld", model.displayNumber.integerValue + 1];
                shop.hidesBottomBarWhenPushed = YES;
                shop.origin = @"0";
                [self.navigationController pushViewController:shop animated:YES];
            }
        } else {
            VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
            controller.isEdit = false;
            controller.companyId = model.companyId;
            controller.origin = @"1";
            [self.navigationController pushViewController:controller animated:true];
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司未开通企业网会员"];
        }
    }
}

#pragma mark - 这里是开启滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopUnionListModel *model = self.dataArray[indexPath.row];
    if ([model.isLeader integerValue]==1) {
        return NO;
    }
    else{
        if (self.isLeader){
            return YES;
        }
        else{
            return NO;
        }
        
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        deleteTag = indexPath.row;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除该成员？"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
//        deleteCaseIndex = path.row;
        alertView.tag = 200;
        [alertView show];
    }];
//    UIContextualAction
    UITableViewRowAction *cancelTopAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"转换盟主" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //这个按钮需要处理的代码块
//        [weakSelf cancelTopConstructionWithIndex:indexPath];
        changeTag = indexPath.row;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认转换盟主？"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        //        deleteCaseIndex = path.row;
        alertView.tag = 300;
        [alertView show];
    }];
    cancelTopAction.backgroundColor = [UIColor lightGrayColor];
    
    ShopUnionListModel *model = self.dataArray[indexPath.row];
    if ([model.isLeader integerValue]==1) {
        //是盟主所在的公司
        //当前人是盟主：不能删也不能转
        //不是盟主：也不能删，不能转
        
        return nil;
    }
    else{
        //不是盟主所在的公司
        //当前人是盟主：能删也能转
        //不是盟主：也不能删，不能转
        if (self.isLeader) {
            return [NSArray arrayWithObjects:cancelTopAction, deleteAction, nil];
        }
        else{
            return nil;
        }
    
    }
}

-(void)editBtnClick:(UIButton *)btn{
    CreatShopUnionController *vc = [[CreatShopUnionController alloc]init];
    vc.IsEdit = 1;
    vc.unionId = self.unionId;
    vc.unionLogo = self.unionLogo;
    vc.unionName = self.unionName;
    vc.unionNumber = self.unionNumber;
    vc.unionPwd = self.unionPwd;
    vc.creatUnionBlock = ^(NSMutableDictionary *dict) {
        self.unionLogo = [dict objectForKey:@"unionLogo"];
        self.unionName = [dict objectForKey:@"unionName"];
        self.unionPwd = [dict objectForKey:@"unionPwd"];
        self.unionNumber = [dict objectForKey:@"unionNumber"];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==200) {
        if (buttonIndex==1) {
            [self deleteUnionMember];
        }
    }
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            [self changeUnionWith:changeTag];
        }
    }
}

#pragma mark - 刷新联盟成员列表

-(void)requestData{
    [self requestUnionDetailInfoWith:self.unionId];
}

-(void)requestUnionDetailInfoWith:(NSInteger)unionId{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"union/getListByCreatePerson.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"unionId":@(unionId),
                               @"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *array = responseObj[@"data"];
                NSDictionary *temDict = array.firstObject;
                NSArray *tempArray = [temDict objectForKey:@"companyList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[ShopUnionListModel class] json:tempArray];
                NSMutableArray *dataArray = [NSMutableArray array];
                [dataArray addObjectsFromArray:arr];
                
                NSString *unionLogo = temDict[@"unionLogo"];
                NSString *unionNumber = temDict[@"unionNumber"];
                NSString *unionName = temDict[@"unionName"];
                NSString *unionId = temDict[@"unionId"];
                NSString *unionPwd = temDict[@"unionPwd"];
                if (!unionPwd) {
                    unionPwd = @"111111";
                }
                BOOL isLeader = [temDict[@"isLeader"] boolValue];
                
                
                
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:dataArray];
                self.unionLogo = unionLogo;
                self.unionNumber = unionNumber;
                self.unionName = unionName;
                self.unionPwd = unionPwd;
                self.unionId = [unionId integerValue];
                self.isLeader = isLeader;
                
                if (self.isLeader) {
                    self.editBtn.hidden = NO;
                    
                    self.bottomV.hidden = NO;
                    self.tableView.frame =CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64-40);
                }
                else{
                    self.editBtn.hidden = YES;
                    self.bottomV.hidden = YES;
                    self.tableView.frame =CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
                }
                [self.tableView reloadData];
                
            }
            else if (statusCode==1001) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
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
                    [selection CreateTableview:QArray withTitle:@"请选择退出的公司" setCompletionBlock:^(int tag) {
                        YSNLog(@"%d",tag);
                        
                        NSDictionary *dict = arr[tag];
                        NSInteger companyId = [[dict objectForKey:@"companyId"]integerValue];
                        [self signOutUnionWith:companyId];
                        //                            [self activityToTop];
                    }
                     ];
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

#pragma mark - 删除联盟成员
-(void)deleteUnionMember{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"unionCompany/delete.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    ShopUnionListModel *model = self.dataArray[deleteTag];
    NSDictionary *paramDic = @{@"unionCompanyId":@(model.companyUnionId),
                               @"agencysId":@(user.agencyId),
                               @"unionId":@(self.unionId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                [self requestData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"没有权限删除" controller:self sleep:1.5];
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

#pragma mark - 退出联盟
-(void)signOutUnionWith:(NSInteger)companyId{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"unionCompany/del.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"companyId":@(companyId),
                               @"agencysId":@(user.agencyId),
                               @"unionId":@(self.unionId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"退出成功" controller:self sleep:1.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您是盟主，不能退出联盟" controller:self sleep:1.5];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"该公司不在联盟内" controller:self sleep:1.5];
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

#pragma mark - 转换盟主
-(void)changeUnionWith:(NSInteger)tag{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"unionCompany/upIsLeader.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    ShopUnionListModel *model = self.dataArray[tag];
    NSDictionary *paramDic = @{@"companyId":model.companyId,
                               @"agencysId":@(user.agencyId),
                               @"unionId":@(self.unionId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"转换成功" controller:self sleep:1.5];
                [self requestData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"当前人员不是盟主" controller:self sleep:1.5];
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

#pragma mark - action
-(void)addBusiness{
    UnionAddBusinessController *vc = [[UnionAddBusinessController alloc]init];
    vc.unionId = self.unionId;
    vc.unionName = self.unionName;
    vc.UnionAddBusBlock = ^{
        [self requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
        [_tableView registerNib:[UINib nibWithNibName:@"ShopUnionListMiddleCell" bundle:nil] forCellReuseIdentifier:@"ShopUnionListMiddleCell"];
        
//        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.separatorColor = kSepLineColor;
    }
    return _tableView;
}

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40, kSCREEN_WIDTH, 40)];
        _bottomV.backgroundColor = White_Color;
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
        [_bottomAddBtn addTarget:self action:@selector(changebtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomAddBtn setImage:[UIImage imageNamed:@"greenAddBtn"] forState:UIControlStateNormal];
    }
    return _bottomAddBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 商户联盟添加企业跳转

-(void)addbtnclick
{
    UnionAddBusinessController *vc = [[UnionAddBusinessController alloc]init];
    vc.unionId = self.unionId;
    vc.unionName = self.unionName;
    vc.UnionAddBusBlock = ^{
        [self requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 创建活动

-(void)changebtnclick
{
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
                    
                    NSArray *QArray = [temArray copy];
                    SSPopup* selection=[[SSPopup alloc]init];
                    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                    
                    selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                    selection.SSPopupDelegate=self;
                    [self.view addSubview:selection];
                    
                    [selection CreateTableview:QArray withTitle:@"请选择活动所属公司" setCompletionBlock:^(int tag) {
                        YSNLog(@"%d",tag);
                        
//                        NSDictionary *dict = arr[tag];
//                        NSInteger companyId = [[dict objectForKey:@"companyId"]integerValue];
//
//                        NSString *companyName = [dict objectForKey:@"companyName"];
//                        NSString *companyLogo = [dict objectForKey:@"companyLogo"];
                        
                     
//                        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
//                        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//                            SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
//                            vc.fromTag = 4;
//                            vc.imgArray = photos;
//                            vc.companyName = companyName;
//                            vc.comanyLogoStr = companyLogo;
//                            vc.companyId = companyId;
//                            vc.unionId = _unionId;
//                            [self.navigationController pushViewController:vc animated:YES];
//                        }];
//
//                        [self presentViewController:imagePickerVc animated:YES completion:nil];
                        //传值
                        NSDictionary *dict = arr[tag];
                        NSInteger companyId = [[dict objectForKey:@"companyId"]integerValue];
                        CreatActivityController *vc = [[CreatActivityController alloc] init];
                        vc.isFistr = YES;
                        vc.companyId = companyId;
                        vc.unionId = _unionId;
               
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                     ];
                    
                    
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

@end
