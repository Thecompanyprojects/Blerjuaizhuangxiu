//
//  NotVipYellowPageViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NotVipYellowPageViewController.h"
#import "YellowPageNotVipView.h"
#import "VipGroupViewController.h"
#import "EditActicleNotVipViewController.h"
#import "YellowActicleView.h"
#import "DesignCaseListModel.h"
#import "ZCHCouponModel.h"
#import "VIPExperienceShowViewController.h"
#import "LocationViewController.h"
#import "DiscountPackageViewController.h"

@interface NotVipYellowPageViewController ()

@end

@implementation NotVipYellowPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费版企业网";
    [self buildNotVipOrArticleView];
}


// 企业会员介绍
- (void)buildNotVipOrArticleView {
    YellowPageNotVipView *v = [[YellowPageNotVipView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    v.OpenVipBlock = ^{
        YSNLog(@"开通vip");
        DiscountPackageViewController *controller = [DiscountPackageViewController new];
        controller.companyId = self.companyID;
        [self.navigationController pushViewController:controller animated:true];
    };
    v.ExperienceVipBlock = ^{
        VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
        controller.companyId = self.companyID;
        controller.companyName = self.companyName;
        controller.modelSubsidiary = self.modelSubsidiary;
        controller.isEdit = self.isEdit;
        controller.origin = self.origin;
        [self.navigationController pushViewController:controller animated:true];
    };
    [self.view addSubview:v];
}

// 美文
- (void)buildNotVipButHaveActicleView {
    YellowActicleView *v = [[YellowActicleView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [v setDesignsId:self.noVipDesignId.integerValue andCompanyId:self.companyID.integerValue];
    [self.view addSubview:v];
}

// 编辑美文
- (void)editArticle {
    [self turnToActivityDetail:self.noVipDesignId.integerValue type:2];
}
#pragma mark - 进入编辑美文和新闻详情页面

-(void)turnToActivityDetail:(NSInteger)designsId type:(NSInteger)type{
    //    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignsDetailsByDesignsId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":@(designsId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                EditActicleNotVipViewController *vc = [[EditActicleNotVipViewController alloc]init];
                //                NSArray *arr = responseObj[@"data"][@"design"];
                NSDictionary *dict = responseObj[@"data"][@"design"];
                
                NSArray *temArray = [dict objectForKey:@"detailsList"];
                NSArray *dataArr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:temArray];
                vc.designId = designsId;
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
                vc.isFistr = NO;
                vc.companyName = self.companyName;
                
                //当前页面使用
//                self.designTitle = [dict objectForKey:@"picUrl"];
//                self.designSubTitle = [dict objectForKey:@"designSubtitle"];
//
//                self.coverMap = [dict objectForKey:@"designTitle"];
//                self.musicStyle = [[dict objectForKey:@"musicPlay"] integerValue];
//                self.order = [[dict objectForKey:@"order"] integerValue];
//                self.templateStr = [dict objectForKey:@"template"] ;
                
//                NSArray *optionArray = [dict objectForKey:@"optionList"];
//                NSArray *arrTwo = [NSArray yy_modelArrayWithClass:[VoteOptionModel class] json:optionArray];
//                [vc.optionList addObjectsFromArray:arrTwo];
                
                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                
                
//                if (type==3) {
//                    //活动
//
//                    NSInteger signUpId = [[activityDict objectForKey:@"activityId"] integerValue];
//                    vc.actId = [NSString stringWithFormat:@"%ld",signUpId];
//
//                    NSString *temStartStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"startTime"]];
//                    vc.actStartTimeStr = [self timeWithTimeIntervalString:temStartStr];
//
//                    NSString *temEndStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"endTime"]];
//                    vc.actEndTimeStr = [self timeWithTimeIntervalString:temEndStr];
//
//                    NSInteger signUpNum = [[activityDict objectForKey:@"activityPerson"] integerValue];
//
//                    vc.signUpNumStr = [NSString stringWithFormat:@"%ld",signUpNum];
//                    vc.activityPlace = [activityDict objectForKey:@"activityPlace"];
//                    vc.activityAddress = [activityDict objectForKey:@"activityAddress"];
//                    NSInteger personNum = [[activityDict objectForKey:@"personNum"] integerValue];
//                    vc.haveSignUpStr = [NSString stringWithFormat:@"%ld",personNum];
//                    NSString *endStr = [activityDict objectForKey:@"activityEnd"];
//                    if (!endStr) {
//                        endStr = @"1";
//                    }
//                    vc.activityEnd = endStr;
//                }
                if (type==2) {
                    //美文
                }
                
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
                vc.customStr = customStr;
                
                //获取红包信息
                
                NSArray *couponArray =[dict objectForKey:@"coupons"];
                
                NSArray *redArray = [NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:couponArray];
                [vc.redArray addObjectsFromArray:redArray];
                
                vc.isFistr = NO;
                vc.unionId = 0;
                
//                vc.companyName = self.companyName;
//                vc.companyLogo = self.companyLogo;
//                vc.companyId = [self.companyId integerValue];

                [self.navigationController pushViewController:vc animated:YES];
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
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
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

@end
