//
//  NewsActivityManageController.m
//  iDecoration
//
//  Created by sty on 2017/12/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NewsActivityManageController.h"
#import "ActivityManageOneCell.h"
#import "ActivityManageTwoCell.h"
#import "ActivityManageThreeCell.h"
#import "ZCHCalculatorPayController.h"

#import "ActivityQRCodeShareView.h"
#import "NSObject+CompressImage.h"

#import "NewsActivityShowController.h"
#import "EditNewsActivityController.h"
#import "NewsActivityManageListController.h"
#import "VoteOptionModel.h"
#import "DesignCaseListModel.h"

#import "SSPopup.h"
#import "VipGroupViewController.h"

@interface NewsActivityManageController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SSPopupDelegate>
{
    NSInteger _tempAgenceId;//0:以公司的身份分享 else：以个人名义分享
    
    UIImage *personImg;
    UIImage *companyImg;
    
    
    NSString *tempStartTime;//临时的活动时间(时间戳)
}

@property (nonatomic, strong) UITableView *tableView;
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;

// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) ActivityQRCodeShareView *TwoDimensionCodeView;

@end

@implementation NewsActivityManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动管理";
    
    [self reloadList];
    
    [self.view addSubview:self.tableView];
    
    [self addBottomShareView];
    [self addTwoDimensionCodeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadList) name:@"refreshNewsActivityList" object:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    else if (section==1){
        return 10;
    }
    else{
        return 30;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 60;
    }
    else{
        return 80;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        UIView *view = [[UIView alloc]init];
        UILabel *LogoName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH-15, 30)];
        LogoName.text = @"快捷操作";
        LogoName.textColor = COLOR_BLACK_CLASS_3;
        LogoName.font = NB_FONTSEIZ_NOR;
        LogoName.textAlignment = NSTextAlignmentLeft;
        [view addSubview:LogoName];
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
        ActivityManageOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityManageOneCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [cell.UnionlogoImgV sd_setImageWithURL:[NSURL URLWithString:self.unionLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        //        cell.UnionnameL.text = self.unionName;
        //        cell.UnionNumL.text = self.unionNumber;
        cell.bowserL.text = self.readNum;
        cell.shareL.text = self.shareNumber;
        cell.signUpL.text = self.personNum;
        //        cell.collectL.text = self.collectionNum;
//        cell.collectL.text = @"0";
        return cell;
    }
    if (indexPath.section==1) {
        ActivityManageTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityManageTwoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSInteger agencyInt = [self.agencysId integerValue];
        cell.editActBlock = ^{
                        if (self.jobTag==1002||self.jobTag==1003||self.jobTag==1027||agencyInt==user.agencyId) {
                            //经理总经理(创建人) 有编辑的权限
                            [self requestActivityDetail];
                        }
                        else{
                            //没有权限
                            [[PublicTool defaultTool] publicToolsHUDStr:@"您没有权限" controller:self sleep:2.0];
                        }
            
            
        };
        cell.manageActBlock = ^{
            NewsActivityManageListController *vc = [[NewsActivityManageListController alloc]init];
            vc.activityId = self.activityId;
            //            vc.unionId = self.unionId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.shareActBlock = ^{
            
//            1公司和员工都没有开通号码通：
//            只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值
//
//            2公司开通 员工没有开通号码通
//            有公司分享按钮和员工分享按钮，点击员工分享按钮提示继续分享和充值，继续分享后收到的报名信息是隐藏的，经理总经理查看提示该员工没有开通号码通，员工查看提示没有开通号码通。
//
//            3公司没有开通 员工开通号码通
//            只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值。
//            4.都开通
//            都显示
            
            if (!self.calVipTag&&!self.meCalVipTag) {
                
                //只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有开通企业号码通!" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        // 会员套餐
                        VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                        VC.companyId = self.companyID;
                        __weak typeof(self) weakSelf = self;
                        VC.successBlock = ^() {
                            weakSelf.calVipTag = 1;
                            [weakSelf refreshPreviousVc:1];
                        };
                        [self.navigationController pushViewController:VC animated:YES];
                        
//                        ZCHCalculatorPayController *payVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
//                        payVC.companyId = self.companyID;
//                        payVC.type = @"0";
//                        __weak typeof(self) weakSelf = self;
//                        payVC.refreshBlock = ^() {
//                            weakSelf.calVipTag = 1;
//                            //
//                            [weakSelf refreshPreviousVc:1];
//                        };
//                        [self.navigationController pushViewController:payVC animated:YES];
                    }
                    if (buttonIndex == 2) {
                        
                        
                        _tempAgenceId = 0;
                        
                        self.shadowView.hidden = NO;
                        
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                        } completion:^(BOOL finished) {
                            self.shadowView.hidden = NO;
                        }];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通",@"继续分享", nil];
                
                [alertView show];
                
                
            }
            else if(self.calVipTag&&!self.meCalVipTag){
                //有公司分享按钮和员工分享按钮，点击员工分享按钮提示继续分享和充值，继续分享后收到的报名信息是隐藏的，经理总经理查看提示该员工没有开通号码通，员工查看提示没有开通号码通。
                SSPopup* selection=[[SSPopup alloc]init];
                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                
                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                selection.SSPopupDelegate=self;
                [self.view addSubview:selection];
                
                __weak typeof(self) weakSelf = self;
                NSArray *QArray = @[@"公司",@"员工"];
                [selection CreateTableview:QArray withTitle:@"分享类型" setCompletionBlock:^(int tag) {
                    YSNLog(@"%d",tag);
                    if (tag==0) {
                        
                        
                        _tempAgenceId = 0;
                        
                        weakSelf.shadowView.hidden = NO;
                        
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            weakSelf.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                        } completion:^(BOOL finished) {
                            weakSelf.shadowView.hidden = NO;
                        }];
                    }
                    if (tag==1) {
                        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有开个人号码通!" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                            
                            if (buttonIndex == 1) {
                                
                                ZCHCalculatorPayController *payVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
                                payVC.companyId = @"0";
                                payVC.type = @"0";
                                payVC.isNotCompany = YES;
                                __weak typeof(self) weakSelf = self;
                                payVC.refreshBlock = ^() {
                                    weakSelf.meCalVipTag = 1;
                                    //
                                    [weakSelf refreshPreviousVc:2];
                                };
                                [self.navigationController pushViewController:payVC animated:YES];
                            }
                            if (buttonIndex == 2) {
                                
                                UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                                _tempAgenceId = user.agencyId;
                                
                                self.shadowView.hidden = NO;
                                
                                [UIView animateWithDuration:0.25 animations:^{
                                    
                                    self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                                } completion:^(BOOL finished) {
                                    self.shadowView.hidden = NO;
                                }];
                            }
                        } cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通",@"继续分享", nil];
                        
                        [alertView show];
                    }
                    
                }
                 ];
            }
            else if(!self.calVipTag&&self.meCalVipTag){
                //只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值。
                
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有开通企业号码通!" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        // 会员套餐
                        VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                        VC.companyId = self.companyID;
                        __weak typeof(self) weakSelf = self;
                        VC.successBlock = ^() {
                            weakSelf.calVipTag = 1;
                            [weakSelf refreshPreviousVc:1];
                        };
                        [self.navigationController pushViewController:VC animated:YES];
                        
//                        ZCHCalculatorPayController *payVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
//                        payVC.companyId = self.companyID;
//                        payVC.type = @"0";
//                        __weak typeof(self) weakSelf = self;
//                        payVC.refreshBlock = ^() {
//                            weakSelf.calVipTag = 1;
//                            //
//                            [weakSelf refreshPreviousVc:1];
//                        };
//                        [self.navigationController pushViewController:payVC animated:YES];
                    }
                    if (buttonIndex == 2) {
                        
                        
                        
                        _tempAgenceId = 0;
                        
                        self.shadowView.hidden = NO;
                        
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                        } completion:^(BOOL finished) {
                            self.shadowView.hidden = NO;
                        }];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通",@"继续分享", nil];
                
                [alertView show];
            }
            else{
                SSPopup* selection=[[SSPopup alloc]init];
                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                
                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                selection.SSPopupDelegate=self;
                [self.view addSubview:selection];
                
                __weak typeof(self) weakSelf = self;
                NSArray *QArray = @[@"公司",@"员工"];
                [selection CreateTableview:QArray withTitle:@"分享类型" setCompletionBlock:^(int tag) {
                    YSNLog(@"%d",tag);
                    if (tag==0) {
                        
                        _tempAgenceId = 0;
                        
                    }
                    if (tag==1) {
                        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                        _tempAgenceId = user.agencyId;
                        
                    }
                    weakSelf.shadowView.hidden = NO;
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        weakSelf.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                    } completion:^(BOOL finished) {
                        weakSelf.shadowView.hidden = NO;
                    }];
                }
                 ];
            }
            
            
            
        };
        
        return cell;
    }
    else{
        ActivityManageThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityManageThreeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger agencyInt = [self.agencysId integerValue];
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        if (agencyInt==user.agencyId){
            
            if (!self.isStop) {
                
                cell.colseSignUpBtn.userInteractionEnabled = YES;
                [cell.colseSignUpBtn setTitle:@"关闭报名" forState:UIControlStateNormal];
                [cell.colseSignUpBtn setTitleColor:Black_Color forState:UIControlStateNormal];
            }
            else{
                cell.colseSignUpBtn.userInteractionEnabled = NO;
                [cell.colseSignUpBtn setTitle:@"报名结束" forState:UIControlStateNormal];
                [cell.colseSignUpBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                
            }
        }else{
            cell.colseSignUpBtn.userInteractionEnabled = YES;
            if (!self.isStop) {
                [cell.colseSignUpBtn setTitle:@"关闭报名" forState:UIControlStateNormal];
                [cell.colseSignUpBtn setTitleColor:Black_Color forState:UIControlStateNormal];
            }
            else{
                [cell.colseSignUpBtn setTitle:@"报名结束" forState:UIControlStateNormal];
                [cell.colseSignUpBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
            }
        }
        cell.lookActBlock = ^{
            NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
            vc.designsId = [self.designsId integerValue];
            vc.activityId = self.activityId;
            vc.origin = @"2";
            vc.designTitle = self.designTitle;
            vc.designSubTitle = self.designSubTitle;
            vc.coverMap = self.coverMap;
            
            vc.companyLandLine = self.companyLandLine;
            vc.companyPhone = self.companyPhone;
            vc.companyId = self.companyID;
            
            vc.companyName = self.companyName;
            vc.companyLogo = self.companyLogo;
            vc.activityAddress = self.activityAddress;
            vc.activityTime = self.activityTime;
            vc.musicStyle = self.musicStyle;
            vc.order = self.order;
            vc.templateStr = self.templateStr;
            vc.activityType = 3;
            vc.calVipTag = self.calVipTag;
            vc.meCalVipTag = self.meCalVipTag;
            vc.agencysId = self.agencysId;
            vc.jobTag = self.jobTag;
            __weak typeof(self) weakSelf = self;
                        vc.activityShowBlock = ^(NSInteger n) {
                            if (n==1) {
                                weakSelf.calVipTag = 1;
                            }
                            if (n==2) {
                                weakSelf.meCalVipTag = 1;
                            }
                            [weakSelf refreshPreviousVc:n];
                        };
            
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.colseActBlock = ^{
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂不可用" controller:self sleep:1.5];
            //            if (agencyInt==user.agencyId) {
            //                //是创建人 关闭报名
            //                if (!self.isStop) {
            //                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认关闭报名？"
            //                                                                        message:@""
            //                                                                       delegate:self
            //                                                              cancelButtonTitle:@"取消"
            //                                                              otherButtonTitles:@"确定", nil];
            ////                    deleteCaseIndex = path.row;
            //                    alertView.tag = 200;
            //                    [alertView show];
            //                }
            //                else{
            //
            //                }
            //            }
            //            else{
            //                //没有权限
            //                [[PublicTool defaultTool] publicToolsHUDStr:@"您没有权限" controller:self sleep:2.0];
            //            }
        };
        cell.republicActBlock = ^{
            [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:2.0];
        };
        return cell;
    }
    return [[UITableViewCell alloc]init];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.section==1) {
    //        ActivityManageController *vc = [[ActivityManageController alloc]init];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
}

#pragma mark - 刷新VIP标志
-(void)refreshPreviousVc:(NSInteger)tag{
    if (self.newsManageShowBlock) {
        self.newsManageShowBlock(tag);
    }
}

#pragma mark - 刷新数据--主要用于编辑活动后再分享使用

-(void)reloadList{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignsDetailsByDesignsId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":self.designsId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                NSDictionary *dict = responseObj[@"data"][@"design"];
                self.designTitle = [dict objectForKey:@"designTitle"];
                self.designSubTitle = [dict objectForKey:@"designSubtitle"];
                self.coverMap = [dict objectForKey:@"coverMap"];
                self.musicStyle = [[dict objectForKey:@"musicPlay"] integerValue];
                self.order = [[dict objectForKey:@"order"] integerValue];
                self.templateStr = [dict objectForKey:@"template"] ;
                
                
                
                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                
                NSString *temStartStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"startTime"]];
                self.activityTime = [self timeWithTimeIntervalString:temStartStr];
                
                tempStartTime = temStartStr;
                
                self.activityAddress = [activityDict objectForKey:@"activityAddress"];
                if (!self.activityAddress||self.activityAddress.length<=0) {
                    self.activityAddress = @"线上活动";
                }
                
                [self setQRShareOfPerson];
                [self setQRShareOfCompany];
                
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
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 请求活动详情

-(void)requestActivityDetail{
    //    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignsDetailsByDesignsId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":self.designsId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                EditNewsActivityController *vc = [[EditNewsActivityController alloc]init];
                NSDictionary *dict = responseObj[@"data"][@"design"];
                
                NSArray *temArray = [dict objectForKey:@"detailsList"];
                NSArray *dataArr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:temArray];
                vc.designId = [self.designsId integerValue];
                [vc.orialArray addObjectsFromArray:dataArr];
                [vc.dataArray addObjectsFromArray:dataArr];
                vc.voteDescribe = [dict objectForKey:@"voteDescribe"];
                vc.voteType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"voteType"]];
                vc.coverTitle = [dict objectForKey:@"designTitle"];
                vc.coverTitleTwo = [dict objectForKey:@"designSubtitle"];
                vc.musicStyle = [[dict objectForKey:@"musicPlay"]integerValue];
                vc.coverImgUrl = [dict objectForKey:@"coverMap"];
                
                vc.endTime = [dict objectForKey:@"voteEndTime"];
                
                vc.musicName = [dict objectForKey:@"musicName"] ;
                vc.musicUrl = [dict objectForKey:@"musicUrl"];
                
                vc.coverImgStr = [dict objectForKey:@"picUrl"] ;
                vc.nameStr = [dict objectForKey:@"picTitle"];
                vc.linkUrl = [dict objectForKey:@"picHref"];
                vc.cost = dict[@"money"];
                vc.costName = dict[@"costName"];
                
                NSArray *couponArray =[dict objectForKey:@"coupons"];
                
                NSArray *redArray = [NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:couponArray];
                [vc.redArray addObjectsFromArray:redArray];
                
                
                NSArray *optionArray = [dict objectForKey:@"optionList"];
                NSArray *arrTwo = [NSArray yy_modelArrayWithClass:[VoteOptionModel class] json:optionArray];
                [vc.optionList addObjectsFromArray:arrTwo];
                
                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                
                
                NSInteger signUpId = [[activityDict objectForKey:@"activityId"] integerValue];
                vc.actId = [NSString stringWithFormat:@"%ld",signUpId];
                
                NSString *temStartStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"startTime"]];
                vc.actStartTimeStr = [self timeWithTimeIntervalString:temStartStr];
                
                NSString *temEndStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"endTime"]];
                //                NSInteger endNum = [[activityDict objectForKey:@"endTime"] integerValue];
                //                vc.actEndTimeStr = [NSString stringWithFormat:@"%ld",endNum];
                vc.actEndTimeStr = [self timeWithTimeIntervalString:temEndStr];
                
                NSInteger signUpNum = [[activityDict objectForKey:@"activityPerson"] integerValue];
                
                vc.signUpNumStr = [NSString stringWithFormat:@"%ld",signUpNum];
                vc.activityPlace = [activityDict objectForKey:@"activityPlace"];
                vc.activityAddress = [activityDict objectForKey:@"activityAddress"];
                NSInteger personNum = [[activityDict objectForKey:@"personNum"] integerValue];
                vc.haveSignUpStr = [NSString stringWithFormat:@"%ld",personNum];
                
                vc.longitude = [activityDict objectForKey:@"longitude"];
                vc.latitude = [activityDict objectForKey:@"latitude"];
                NSString *endStr = [activityDict objectForKey:@"activityEnd"];
                if (!endStr) {
                    endStr = @"1";
                }
                vc.activityEnd = endStr;
                
                
                NSString *customStr =[activityDict objectForKey:@"custom"];
                if (customStr.length<=0) {
                    vc.setDataArray = [NSMutableArray array];
                }
                else{
                    NSData *data = [customStr dataUsingEncoding:NSUTF8StringEncoding];
                    id temID = [self toArrayOrNSDictionary:data];
                    if ([temID isKindOfClass:[NSArray class]]) {
                        NSArray *temArray = temID;
                        vc.setDataArray = [NSMutableArray array];
                        [vc.setDataArray addObjectsFromArray:temArray];
                    }
                    else{
                        vc.setDataArray = [NSMutableArray array];
                    }
                }
                self.customStr = customStr;
                vc.customStr = self.customStr;
                
                //                if (customArray.count>0) {
                //
                //                }
                //                else{
                //                    [vc.setDataArray addObjectsFromArray:customArray];
                //                }
                //                [vc.setDataArray addObjectsFromArray:customArray];
                
                vc.isFistr = NO;
                vc.unionId = 0;
                //                vc.companyId = [self.companyID integerValue];
                vc.companyName = self.companyName;
                vc.companyLogo =self.companyLogo;
                vc.companyId = [self.companyID integerValue];
                
                //                vc.reloadBlock = ^{
                //
                //                };
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
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 生成个人二维码
- (void)setQRShareOfPerson{
    [self.TwoDimensionCodeView.topImageView sd_setImageWithURL:[NSURL URLWithString:self.coverMap] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.companyName = self.companyName;
    self.TwoDimensionCodeView.activityName = self.designTitle;
    [self.TwoDimensionCodeView.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil options:SDWebImageRetryFailed];
//    self.TwoDimensionCodeView.activityTime = self.activityTime;
    self.TwoDimensionCodeView.activityTime = tempStartTime;
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }
    //    NSString *companyStr = self.companyId;
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverMap]];
    //    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.TwoDimensionCodeView.QRcodeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            UIImage *img = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            personImg = img;
        });
    });
}

#pragma mark - 生成公司二维码
- (void)setQRShareOfCompany{
    [self.TwoDimensionCodeView.topImageView sd_setImageWithURL:[NSURL URLWithString:self.coverMap] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.companyName = self.companyName;
    self.TwoDimensionCodeView.activityName = self.designTitle;
    [self.TwoDimensionCodeView.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil options:SDWebImageRetryFailed];
//    self.TwoDimensionCodeView.activityTime = self.activityTime;
    self.TwoDimensionCodeView.activityTime = tempStartTime;
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }
    //    NSString *companyStr = self.companyId;
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverMap]];
    //    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.TwoDimensionCodeView.QRcodeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            UIImage *img = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            companyImg = img;
        });
    });
}

//-(void)callPhoneWith:(NSString *)phoneStr{
//
//}

- (void)addBottomShareView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomShareView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/2.0 + 70)];
    self.bottomShareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.shadowView addSubview:self.bottomShareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"分享给好友";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomShareView addSubview:titleLabel];
    
    NSArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0"];
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"二维码"];
    for (int i = 0; i < 5; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%4 * BLEJWidth * 0.25, titleLabel.bottom + 20 + (i/4 * BLEJWidth * 0.25), BLEJWidth * 0.25, BLEJWidth * 0.25)];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickShareContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        [self.bottomShareView addSubview:btn];
    }
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
    
    self.TwoDimensionCodeView.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
}

#pragma mark - 添加二维码
- (void)addTwoDimensionCodeView {
    
    
    self.TwoDimensionCodeView = [[ActivityQRCodeShareView alloc] init];
    self.TwoDimensionCodeView.frame = [UIScreen mainScreen].bounds;
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    self.TwoDimensionCodeView.hidden = YES;
}

- (void)setQRShare {
    [self.TwoDimensionCodeView.topImageView sd_setImageWithURL:[NSURL URLWithString:self.coverMap] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.companyName = self.companyName;
    self.TwoDimensionCodeView.activityName =  self.designTitle;
    [self.TwoDimensionCodeView.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.activityTime = self.activityTime;
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }
    //    NSString *companyStr = self.companyId;
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverMap]];
    //    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.TwoDimensionCodeView.QRcodeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
        });
    });
    
    
}

- (void)didClickShareContentBtn:(UIButton *)btn {
    
    NSString *shareTitle = self.designTitle;
    NSString *shareDescription = self.designSubTitle;
    NSURL *shareImageUrl;
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
//    if (self.coverMap) {
//        shareImageUrl = [NSURL URLWithString:self.coverMap];
//    }
    shareImageUrl = [NSURL URLWithString:self.coverMap];
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.coverMap) {
                [message setThumbImage:img];
            } else {
                UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                [message setThumbImage:image];
            }
            
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            //resources/html/shigongrizhi1.jsp?constructionId=%ld
            if (!user.agencyId) {
                user.agencyId = 0;
            }
            //            if (!self.companyId||self.companyId.length<=0) {
            //                self.companyId = @"0";
            //            }
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
            
            if (!_tempAgenceId) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)0]];
            }
            else{
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
            }
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                //                [MobClick event:@"ConstructionDiaryShare"];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.coverMap) {
                [message setThumbImage:img];
            } else {
                [message setThumbImage:[UIImage imageNamed:@"shareDefaultIcon"]];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            if (!user.agencyId) {
                user.agencyId = 0;
            }
            //            if (!self.companyId||self.companyId.length<=0) {
            //                self.companyId = @"0";
            //            }
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
            
            if (!_tempAgenceId) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)0]];
            }
            else{
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
            }
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                //                [MobClick event:@"ConstructionDiaryShare"];
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 2:
        {// QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                //                NSString *shareURL = WebPageUrl;
                //                NSString *shareURL = @"https://www.baidu.com";
                
                if (!user.agencyId) {
                    user.agencyId = 0;
                }
                //                if (!self.companyId||self.companyId.length<=0) {
                //                    self.companyId = @"0";
                //                }
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
                if (!_tempAgenceId) {
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)0]];
                }
                else{
                    [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
                }
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                //                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:[NSString stringWithFormat:@"爱装修--%@", self.model.companyName] description:[NSString stringWithFormat:@"爱装修--%@", self.model.companyName] previewImageData:data];
                
                
                
                //                NSURL *url = [NSURL URLWithString:shareURL];
                // title = 分享标题
                // description = 施工单位 小区名称
                
                
                QQApiNewsObject *newObject;
                if (self.coverMap) {
                    //                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageURL:shareImageUrl];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    //                    NSData *dataOne = UIImagePNGRepresentation(image);
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    //                    [MobClick event:@"ConstructionDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            
            break;
        case 3:
        {// QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                if (!user.agencyId) {
                    user.agencyId = 0;
                }
                //                if (!self.companyId||self.companyId.length<=0) {
                //                    self.companyId = @"0";
                //                }
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
                
                if (!_tempAgenceId) {
                    [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)0]];
                }
                else{
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
                }
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                
                QQApiNewsObject *newObject;
                if (self.coverMap) {
                    //                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageURL:shareImageUrl];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    //                    NSData *data = UIImagePNGRepresentation(image);
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    //                    [MobClick event:@"ConstructionDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            break;
        case 4:
        {// 生成二维码
            //            [MobClick event:@"ConstructionDiaryShare"];
            
            if (!_tempAgenceId) {
                self.TwoDimensionCodeView.QRcodeView.image = companyImg;
            }
            else{
                self.TwoDimensionCodeView.QRcodeView.image = personImg;
            }
            self.TwoDimensionCodeView.hidden = NO;
            self.navigationController.navigationBar.alpha = 0;
        }
            break;
        default:
            break;
    }
    [self shareNumberCount];
}

- (void)shareNumberCount {
    UserInfoModel *userInfo = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyID = [NSString stringWithFormat:@"%ld", (long)userInfo.agencyId];
    NSString *urlStr = [NSString stringWithFormat:@"cblejActivity/addShareNumber/%@.do", self.activityId];
    NSString *defaultApi = [BASEURL stringByAppendingString:urlStr];
    NSDictionary *paramDic = @{
                               @"agencyId":agencyID
                               };
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];
}
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"ActivityManageOneCell" bundle:nil] forCellReuseIdentifier:@"ActivityManageOneCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ActivityManageTwoCell" bundle:nil] forCellReuseIdentifier:@"ActivityManageTwoCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ActivityManageThreeCell" bundle:nil] forCellReuseIdentifier:@"ActivityManageThreeCell"];
        
        //        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.separatorColor = kSepLineColor;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
