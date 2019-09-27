//
//  NewDesignImageWebController.h
//  iDecoration
//
//  Created by sty on 2017/9/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "ZCHCouponModel.h"

@interface NewDesignImageWebController : SNViewController
@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger consID;

@property (nonatomic, assign) BOOL isPower;
@property (nonatomic, assign) BOOL isComplate;//是否交工
@property (nonatomic, assign) BOOL isFistr;//是否是第一次添加

@property (nonatomic, assign) NSInteger fromIndex;//1:本案设计。2:店长手记
@property (nonatomic, copy) NSString *companyId;//公司或店铺id

@property (nonatomic, strong) NSMutableArray *orialArray;//原始数组
@property (nonatomic, strong) NSMutableArray *dataArray;//临时数组
@property (nonatomic, strong) NSMutableArray *redArray;//红包的数量

@property (nonatomic, copy) NSString *voteType;//投票类型
@property (nonatomic, copy) NSString *voteDescribe;//投票描述
@property (nonatomic, strong) NSMutableArray *optionList;//投票数组
@property (nonatomic, copy) NSString *endTime;//截止时间


@property (nonatomic, copy) NSString *coverTitle;//封面标题
@property (nonatomic, copy) NSString *coverTitleTwo;//封面副标题
@property (nonatomic, copy) NSString *coverImgUrl;//封面图片

@property (nonatomic, copy) NSString *musicUrl;//音乐地址
@property (nonatomic, copy) NSString *musicName;//音乐名称

@property (nonatomic, assign) NSInteger designId;

@property (nonatomic, strong) NSString *coverImgStr;//全景封面
@property (nonatomic, strong) NSString *nameStr;//全景名称
@property (nonatomic, strong) NSString *linkUrl;//全景链接

@property (nonatomic, copy) NSString *companyLogo; // 公司logo ，生成二维码用
@property (nonatomic, copy) NSString *companyName;//公司名称，加水印使用
@property (nonatomic, assign) NSInteger musicStyle;//0:自动播放 1:点击播放
@property (nonatomic, assign) NSInteger order;//图文显示位置（0：图上字下，1：图下字上）
@property (nonatomic, copy) NSString *templateStr;//模版地址

@property (nonatomic,assign) BOOL isfromlocal;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic,copy) NSString *companyType;
@property (nonatomic,copy) NSString *constructionType;
@end
