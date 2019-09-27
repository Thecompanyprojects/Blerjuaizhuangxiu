//
//  ActivitySignUpTwoController.h
//  iDecoration
//
//  Created by sty on 2017/11/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ActivitySignUpTwoController : SNViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *customStrArray;
@property (nonatomic, strong) NSMutableArray *customBoolArray;


@property(nonatomic,copy)NSString *designsId;//活动主体信息
@property(nonatomic,copy)NSString *activityId;//活动id
@property (nonatomic, copy) NSString *companyId; // 公司ID
@property(nonatomic,copy)NSString *designTitle;//主标题
@property(nonatomic,copy)NSString *designSubTitle;//副标题
@property(nonatomic,copy)NSString *coverMap;//封面

@property(nonatomic,copy)NSString *activityAdress;//活动地址
@property(nonatomic,copy)NSString *activityName;//活动名称
@end
