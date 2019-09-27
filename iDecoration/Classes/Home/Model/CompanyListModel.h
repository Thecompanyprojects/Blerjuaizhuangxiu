//
//  CompanyListModel.h
//  iDecoration
//
//  Created by Apple on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"

@interface CompanyListModel : HomeBaseModel

//private Long companyId;//公司id
//private String companyName;//公司名称
//private String companyLogo;//公司logo
//private String companyNumber;//公司号
//private String companySlogan;//公司标语
//private Integer headQuarters;//是否为总公司(0：不是，1：是）
//private Long pid;//上级公司id
//private Long createPerson;//创建人id
//private Date createTime;//创建时间
//private Date vipStartTime;//会员开通时间
//private Date vipEndTime;//会员结束时间
//private String companyLandline;//公司座机号
//private String companyPhone;//公司手机号
//private String companyWx;//公司微信
//private String companyAddress;//公司详细地址
//private Integer companyProvince;//公司所属省
//private Integer companyCity;//公司所属市
//private Integer companyCounty;//公司所属区县
//private String companyIntroduction;//公司简介
//private Integer customizedVip = 0;//是否开通定制会员（0：未开通，1：已开通）
//
////常用字段
//private Long agencysId;//人员id
//private Long jobId;//职位id
//
//private String trueName;//总经理姓名
//private String phone;//总经理电话号码
//private String companyName2;//总公司名称
//private String Landline;
//
////案例数量
//private int caseTotla;
////设计师
//private int designerTotal;
////工长
//private int foremanTotal;
////监理
//private int supervisorTotal;
////好评
//private int praiseTotal;
////工地数
//private int constructionTotal;
////服务评价
//private Integer serviceGrade;
////价格评价
//private Integer priceGrade;
////设计评价
//private Integer designGrade;
////施工评价
//private Integer qualityGrade;
////工期评价
//private Integer speedGrade;
////总评价
//private Integer sumGrade;
////工地状态
//private Integer ccComplete;
//
//private Integer times;
//
//private Date appVipStartTime;//前段会员开通时间
//private Date appVipEndTime;//后端会员结束时间
//private String extend;
//private Integer merchantNum;//公司入驻商家数量

@property (nonatomic, assign) NSInteger headQuarters;
@property (nonatomic, assign) NSInteger designerTotal;
@property (nonatomic, assign) NSInteger createPerson;
@property (nonatomic, assign) NSInteger agencysId;
@property (nonatomic, assign) long long appVipEndTime;
@property (nonatomic, copy) NSString *companyName2;
@property (nonatomic, assign) NSInteger supervisorTotal;
@property (nonatomic, copy) NSString *merchantLandline;
@property (nonatomic, copy) NSString *landline;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *vipEndTime;
@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, assign) long long appVipStartTime;
@property (nonatomic, copy) NSString *companyNumber;
@property (nonatomic, copy) NSString *foremanTotal;
@property (nonatomic, copy) NSString *times;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *phone;
@property (copy, nonatomic) NSString *merchantLogo;
@property (copy, nonatomic) NSString *merchantName;
@property (assign, nonatomic) NSInteger merchantId;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *praiseTotal;
@property (nonatomic, copy) NSString *extend;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *companySlogan;
@property (nonatomic, copy) NSString *address;
@property (copy, nonatomic) NSString *countyName;

@property (copy, nonatomic) NSString *vipState;

@property (copy, nonatomic) NSString *seeFlag;

@property (nonatomic, copy) NSString *companyIntroduction;
// 收藏的公司ID
@property (nonatomic, assign) NSInteger collectionId;

// 收藏量
@property (copy, nonatomic) NSString *collectionNumbers;
// 浏览量
@property (copy, nonatomic) NSString *browse;


// 案例数  已交工工地数
@property (nonatomic, copy) NSString *caseTotla;
//未交工工地数量
@property (nonatomic, copy) NSString *constructionTotal;
// 商家商品量
@property (nonatomic, copy) NSString *total;
// 展现量
@property (copy, nonatomic) NSString *displayNumbers;
// 认证状态（0：未交认证费，1：待认证，2：已认证，3：认证失败，4：认证过期）
@property (nonatomic, copy) NSString *status;
// 1是0不是 钻石会员
@property (nonatomic, strong) NSString *recommendVip;

@end
