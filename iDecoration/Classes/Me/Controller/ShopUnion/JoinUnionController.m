//
//  JoinUnionController.m
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "JoinUnionController.h"
#import "MyCompanyHeadCell.h"
#import "MeViewController.h"
#import "ShopUnionListController.h"
#import "ShopUnionListModel.h"

@interface JoinUnionController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *pwdTextF;
@end

@implementation JoinUnionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请加入联盟";
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0.5;
    }
    else{
        return 170;
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 80;
    }
    else{
        return 41;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section==0) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = kSepLineColor;
        return view;
    }
    else{
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = White_Color;
        UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        successBtn.frame = CGRectMake(30,30,kSCREEN_WIDTH-60,40);
        successBtn.backgroundColor = Main_Color;
        [successBtn setTitle:@"完  成" forState:UIControlStateNormal];
        successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [successBtn setTitleColor:White_Color forState:UIControlStateNormal];
        successBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        successBtn.layer.masksToBounds = YES;
        successBtn.layer.cornerRadius = 5;
        [successBtn addTarget:self action:@selector(pushData) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:successBtn];
        
        UIButton *reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reviewBtn.frame = CGRectMake(30,successBtn.bottom+30,kSCREEN_WIDTH-60,40);
        reviewBtn.backgroundColor = Main_Color;
        [reviewBtn setTitle:@"申请加入" forState:UIControlStateNormal];
        reviewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [reviewBtn setTitleColor:White_Color forState:UIControlStateNormal];
        reviewBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        reviewBtn.layer.masksToBounds = YES;
        reviewBtn.layer.cornerRadius = 5;
        [reviewBtn addTarget:self action:@selector(reviewData) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:reviewBtn];
        return view;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        MyCompanyHeadCell *cell = [MyCompanyHeadCell cellWithTableView:tableView];
        [cell configWith:self.model];
        
        cell.editBtn.hidden = YES;
        
        
        
        return cell;
    }
    else{
        NSString *cellIdendifier = @"joinUnionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdendifier];;
        }
        cell.contentView.backgroundColor = White_Color;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"联盟密码";
        cell.detailTextLabel.hidden = YES;
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, kSCREEN_WIDTH-100-15, 40)];
        textF.textColor = COLOR_BLACK_CLASS_3;
        textF.font = [UIFont systemFontOfSize:14];
        [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
        textF.placeholder = @"请输入联盟密码";
        textF.textAlignment = NSTextAlignmentRight;
        if (!_pwdTextF) {
            _pwdTextF = textF;
        }
        [cell addSubview:self.pwdTextF];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(15, textF.bottom, kSCREEN_WIDTH-15, 0.5)];
        lineV.backgroundColor = kSepLineColor;
        [cell addSubview:lineV];
        return cell;
    }
    return [[UITableViewCell alloc]init];
    
}

#pragma mark - 申请联盟
-(void)pushData{
    [self.view endEditing:YES];
    self.pwdTextF.text = [self.pwdTextF.text ew_removeSpaces];
    if (self.pwdTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"联盟密码不能为空" controller:self sleep:1.5];
        return;
    }
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"unionCompany/save.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"companyId":@(self.companyId),
                               @"unionId":self.model.unionId,
                               @"unionPwd":self.pwdTextF.text,
                               @"companyName":self.companyName,
                               @"unionName":self.model.unionName
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            //1000:成功，1002：该公司已经加入联盟，1003：联盟不存在，1004：联盟密码错误，2000：失败
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                NSString *str = [NSString stringWithFormat:@"成功加入%@联盟",self.model.unionName];
                [[PublicTool defaultTool] publicToolsHUDStr:str controller:self sleep:1.5];
                NSInteger idTag =[self.model.unionId integerValue];
                //直接进入联盟
                [self requestUnionDetailInfoWith:idTag];
            
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"该公司已在当前联盟" controller:self sleep:1.5];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"联盟不存在" controller:self sleep:1.5];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"密码错误,请重新输入或者申请加入" controller:self sleep:1.5];
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

#pragma mark - 查询联盟详情
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
                BOOL isZManage = [temDict[@"zjl"] boolValue];
                BOOL isFManage = [temDict[@"jl"] boolValue];
                
                ShopUnionListController *vc = [[ShopUnionListController alloc]init];
                vc.dataArray = dataArray;
                vc.unionLogo = unionLogo;
                vc.unionNumber = unionNumber;
                vc.unionName = unionName;
                vc.unionPwd = unionPwd;
                vc.unionId = [unionId integerValue];
                vc.isLeader = isLeader;
                vc.isZManage = isZManage;
                vc.isFManage = isFManage;
                [self.navigationController pushViewController:vc animated:YES];
                
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

#pragma mark - 申请加入联盟
-(void)reviewData{
    [self.view endEditing:YES];
//    self.pwdTextF.text = [self.pwdTextF.text ew_removeSpaces];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"unionApply/save.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"companyId":@(self.companyId),
                               @"unionId":self.model.unionId,
                               @"agencysId":@(user.agencyId),
                               @"trueName":user.trueName,
                               @"companyName":self.companyName,
                               @"unionName":self.model.unionName
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        

        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"申请成功,请耐心等待" controller:self sleep:1.5];
                
                
//                __weak typeof(self) weakSelf = self;
//                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                    for (UIViewController *vc in self.navigationController.childViewControllers) {
//                        if ([vc isKindOfClass:[MeViewController class]]) {
//                            [weakSelf.navigationController popToViewController:vc animated:YES];
//                        }
//                    }
//                });
                
                
                
                
            }
//            else if (statusCode==1002) {
//                [[PublicTool defaultTool] publicToolsHUDStr:@"该公司已经加入联盟" controller:self sleep:1.5];
//            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已发送过申请消息" controller:self sleep:1.5];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"该公司已在当前联盟" controller:self sleep:1.5];
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


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = White_Color;
        //        [_tableView addHeaderWithTarget:self action:@selector(loadData)];
        //        [_tableView addFooterWithTarget:self action:@selector(upLoadData)];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
