//
//  NewsActivityManageController.h
//  iDecoration
//
//  Created by sty on 2017/12/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"



@interface NewsActivityManageController : SNViewController

@property (nonatomic, copy) void(^newsManageShowBlock)(NSInteger n);//n:1 代表开通的是公司号码通vip 2:开通的是个人号码通vip;

@property(nonatomic,copy)NSString *designsId;//活动主体信息
@property(nonatomic,copy)NSString *activityId;//活动id
@property(nonatomic,copy)NSString *agencysId;//创建活动人员id

@property (nonatomic, assign) NSInteger unionId;//联盟id

@property(nonatomic,copy)NSString *readNum;//浏览量
@property(nonatomic,copy)NSString *shareNumber;//分享数
@property(nonatomic,copy)NSString *personNum;//已报名人数
@property(nonatomic,copy)NSString *collectionNum;//收藏量


@property(nonatomic,copy)NSString *designTitle;//主标题
@property(nonatomic,copy)NSString *designSubTitle;//副标题
@property(nonatomic,copy)NSString *coverMap;//封面

@property (nonatomic, copy) NSString *customStr;//自定义项

// 分享需要
//公司名称
@property (nonatomic, copy) NSString *companyName;
// 公司logo
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyID; // 公司ID
@property(nonatomic,copy)NSString *companyLandLine;//座机号
@property(nonatomic,copy)NSString *companyPhone;//手机号
@property (nonatomic, assign) NSInteger calVipTag;//0:未开通公司计算器会员  1:开通
@property (nonatomic, assign) NSInteger meCalVipTag;//0:该人员未开通个人计算器会员  1:开通
// 活动开始时间
@property (nonatomic, copy) NSString *activityTime;
// 活动地址
@property (nonatomic, copy) NSString *activityAddress;

@property (nonatomic, assign) NSInteger jobTag;//职位id



@property (nonatomic, assign) NSInteger isStop;// 0:未关闭报名 1:已关闭报名

@property (nonatomic, assign) NSInteger musicStyle;//0:自动播放 1:点击播放
@property (nonatomic, assign) NSInteger order;//图文显示位置（0：图上字下，1：图下字上）
@property (nonatomic, copy) NSString *templateStr;//模版地址
@end
