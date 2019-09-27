//
//  SubsidiaryModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//


// 公司详情model


#import <Foundation/Foundation.h>
#import "HomeClassificationDetailModel.h"
#import "HomeBaseModel.h"
@interface SubsidiaryModel : HomeBaseModel
/**
 判断是否为公司还是商铺
 */
@property (assign, nonatomic) BOOL isCompany;
@property (strong, nonatomic) UIImage *imageLogo;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *agencysJob;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *agencysId;
@property (nonatomic, copy) NSString *headQuarters;
@property (nonatomic, copy) NSString *companySlogan;
@property (nonatomic, copy) NSString *typeName;//类型名称
@property (strong, nonatomic) NSMutableArray *arrayBasicTitle;
@property (strong, nonatomic) NSMutableArray *arrayBasicTitleInShow;
@property (strong, nonatomic) NSMutableArray *arrayBasic;
@property (strong, nonatomic) NSMutableArray *arrayBasicInShow;
@property (strong, nonatomic) NSMutableArray *areaList;
@property (strong, nonatomic) NSString *areaListString;
//@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSString *serviceScope;
@property (nonatomic, copy) NSString *companyWx;
@property (nonatomic, copy) NSString *companyNumber;
// >0: 表示是会员   =1: 是收费的(400一年(每添加一个商家))   =2: 随便添加商家
@property (nonatomic, copy) NSString *customizedVip;  // 是否是定制会员（0：不是，1，2：是）
@property (nonatomic, copy) NSString *companyLogo;
// 1018 公司  != 1018  都是店铺
@property (nonatomic, copy) NSString *companyType;
@property (nonatomic, copy) NSString *companyIntroduction;
@property (nonatomic, copy) NSString *companyId;
// 企业网会员结束时间   没有开通返回""   开通的返回格式 2017-09-06 17:11:44
@property (nonatomic, copy) NSString *appVipEndTime;
@property (nonatomic, copy) NSString *merchantNo;
@property (copy, nonatomic) NSString *detailedAddress;
@property (copy, nonatomic) NSString *seeFlag;

@property (copy, nonatomic) NSString *companyProvince;
@property (copy, nonatomic) NSString *companyCity;
@property (copy, nonatomic) NSString *companyCounty;

@property (copy, nonatomic) NSString *companyEmail;//邮箱代替手机号
@property (copy, nonatomic) NSString *companyUrl;//网址代替微信号
@property (copy, nonatomic) NSString *appVip; // 是否是企业网会员（0：否，1：是）
@property (copy, nonatomic) NSString *calVip;//计算器会员   是否为计算器会员 0：否 1：是
@property (copy, nonatomic) NSString *smsVip;
@property (copy, nonatomic) NSString *conVip;//云管理会员    是否为云管理会员 0：否 1：是
@property (copy, nonatomic) NSString *recommendVip;//是否开通会员成长计划   0：否 1：是
@property (assign, nonatomic) BOOL svip;//是否开通9800   0：否 1：是

@property (copy, nonatomic) NSString *recommendVipEndTime;//会员成长计划结束时间  没有返回为“”  2019-06-07 11:03:17
@property (copy, nonatomic) NSString *calEndTime;//计算器会员结束时间  没有返回为“”  2019-06-07 11:03:17
@property (copy, nonatomic) NSString *vipEndTime;//云管理会员结束时间  没有返回为“”  2019-06-07 11:03:17
@property (copy, nonatomic) NSString *smsEnd;
@property (nonatomic, copy) NSString *longitude; // 经度
@property (nonatomic, copy) NSString *latitude; // 纬度


//@property (nonatomic,copy) NSString *implement;//是否是执行经理
@property (assign, nonatomic) BOOL implement;

// 非会员美文ID
@property (nonatomic, copy) NSString *noVipDesignId;
// 认证状态（0：未交认证费，1：待认证，2：已认证，3：认证失败，4：认证过期）
@property (nonatomic, copy) NSString *status;
@property (assign, nonatomic) NSInteger certificateStatus;

/**
 广告上
 */
@property (strong, nonatomic) NSMutableArray *arrayADTop;

/**
 广告下
 */
@property (strong, nonatomic) NSMutableArray *arrayADBottom;
//@property (strong, nonatomic) NSMutableArray *arrayADTopData;
//@property (strong, nonatomic) NSMutableArray *arrayADBottomData;
/**

 */
@property (strong, nonatomic) NSArray *footImgs;
@property (strong, nonatomic) NSArray *headImgs;
@property (copy, nonatomic) NSString *picHref;
@property (copy, nonatomic) NSString *picId;
@property (copy, nonatomic) NSString *picTitle;
@property (copy, nonatomic) NSString *picUrl;
@property (copy, nonatomic) NSString *relId;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL isImageChanged;
@property (assign, nonatomic) CGFloat imageHeight;
@property (assign, nonatomic) NSInteger authentication;//0未认证1已认证

@end
