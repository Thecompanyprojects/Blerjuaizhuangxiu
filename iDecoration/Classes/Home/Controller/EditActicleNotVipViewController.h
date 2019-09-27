//
//  EditActicleNotVipViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface EditActicleNotVipViewController : SNViewController

@property (nonatomic, assign) BOOL isFistr;//是否是第一次添加
@property (nonatomic, assign) BOOL isComplate;//是否交工
@property (nonatomic, assign) BOOL isPower;

@property (nonatomic, copy) NSString *voteType;//投票类型
@property (nonatomic, copy) NSString *voteDescribe;//投票描述
@property (nonatomic, strong) NSMutableArray *optionList;//投票数组
@property (nonatomic, copy) NSString *endTime;//截止时间

@property (nonatomic, copy) NSString *coverTitle;//封面标题
@property (nonatomic, copy) NSString *coverTitleTwo;//封面副标题
@property (nonatomic, copy) NSString *coverImgUrl;//封面图片

@property (nonatomic, strong) NSMutableArray *orialArray;//原始数组
@property (nonatomic, strong) NSMutableArray *dataArray;//临时数组
@property (nonatomic, strong) NSMutableArray *redArray;//红包的数量

@property (nonatomic, copy) NSString *musicUrl;//音乐地址
@property (nonatomic, copy) NSString *musicName;//音乐名称

@property (nonatomic, assign) NSInteger designId;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, copy) NSString *companyName; // 公司名称 ，生成二维码用
@property (nonatomic, copy) NSString *companyLogo; // 公司logo ，生成二维码用
@property (nonatomic, assign) NSInteger jobTag;//身份职位

@property (nonatomic, copy) NSString *myContructLink;//我的工地链接

@property (nonatomic, copy) NSString *coverImgStr;//全景封面
@property (nonatomic, copy) NSString *nameStr;//全景名称
@property (nonatomic, copy) NSString *linkUrl;//全景链接

@property (nonatomic, assign) NSInteger unionId;//联盟id
@property (nonatomic, strong) NSMutableArray *setDataArray;
@property (nonatomic, copy) NSString *actId;//活动id
@property (nonatomic, copy) NSString *actStartTimeStr;//活动开始时间
@property (nonatomic, copy) NSString *actEndTimeStr;//活动结束时间
@property (nonatomic, copy) NSString *signUpNumStr;//活动总人数 0：不限制
@property (nonatomic, copy) NSString *haveSignUpStr;//活动报名人数
@property (nonatomic, copy) NSString *customStr;//自定义项

@property (nonatomic, copy) NSString *activityPlace;//0:线下，1：线上
@property (nonatomic, copy) NSString *activityAddress;//活动地址
@property (nonatomic, copy) NSString *activityEnd;//0:活动结束之前截止报名，1：活动开始前截止报名
@property (nonatomic, copy) NSString *longitude;//活动经纬度
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *cost; // 活动费用
@property (nonatomic, copy) NSString *costName; // 活动费用名称

@property (nonatomic, assign) NSInteger musicStyle;//0:自动播放 1:点击播放

@end
