//
//  NewsActivityShowController.h
//  iDecoration
//
//  Created by sty on 2017/12/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "ZCHCouponModel.h"

@interface NewsActivityShowController : SNViewController

@property (nonatomic, copy) void(^activityShowBlock)(NSInteger n);//n:1 代表开通的是公司号码通vip 2:开通的是个人号码通vip;
@property(nonatomic,assign)NSInteger designsId;//活动主体信息

@property (nonatomic,assign) NSInteger activityType;// 2:美文，3：活动
@property(nonatomic,copy)NSString *activityId;//活动id
@property(nonatomic,copy)NSString *agencysId;//创建活动人员id

@property (nonatomic, copy) NSString *companyId; // 公司ID
@property(nonatomic,copy)NSString *companyName;//公司名称
@property(nonatomic,copy)NSString *companyLogo;//公司logo

@property(nonatomic,copy)NSString *companyLandLine;//座机号
@property(nonatomic,copy)NSString *companyPhone;//手机号
@property (nonatomic, assign) NSInteger jobTag;//身份职位(公司活动需要)

@property (nonatomic, strong) NSMutableArray *redArray;

@property(nonatomic,copy)NSString *designTitle;//主标题
@property(nonatomic,copy)NSString *designSubTitle;//副标题
@property(nonatomic,copy)NSString *coverMap;//封面

@property (nonatomic, copy) NSString *activityAddress;
@property (nonatomic, copy) NSString *activityTime;

@property (nonatomic, assign) NSInteger musicStyle;//0:自动播放 1:点击播放
@property (nonatomic, assign) NSInteger order;//图文显示位置（0：图上字下，1：图下字上）
@property (nonatomic, copy) NSString *templateStr;//模版地址

@property (nonatomic, assign) NSInteger calVipTag;//0:未开通公司计算器会员  1:开通
@property (nonatomic, assign) NSInteger meCalVipTag;//0:未开通个人计算器会员  1:开通
@property (assign, nonatomic) NSInteger money;

@property (nonatomic,copy) NSString *origin;

@end
