//
//  HanZXModel.h
//  iDecoration
//
//  Created by RealSeven on 17/3/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageObject;

@interface HanZXModel : NSObject


// 最新是数据
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, assign) NSInteger decorationId;
@property (nonatomic, assign) NSInteger proType;
@property (nonatomic, copy) NSString *calVip;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger agencyId;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) NSInteger personCalVip;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger isRead;
@property (nonatomic, copy) NSString *addTime; // 1522057229000 毫秒
@property (nonatomic, assign) NSInteger recommendVip;

//老数据字段
@property (nonatomic, copy) NSString *areaHouse;//面积
@property (nonatomic, copy) NSString *constructionId;//工地id
@property (nonatomic, copy) NSString *dingdate;//订单日期
@property (nonatomic, copy) NSString *elephone;//另外的联系方式

@property (nonatomic, copy) NSString *houseType;//装修类型
@property (nonatomic, assign) NSInteger hanId;//喊装修订单id

@property (nonatomic, copy) NSString *month;//月份
@property (nonatomic, copy) NSString *name;//客户姓名
@property (nonatomic, copy) NSString *pay;//预算

@property (nonatomic, copy) NSString *qu;//区
@property (nonatomic, copy) NSString *sheng;//省
@property (nonatomic, copy) NSString *shi;//市

// 新老数据共有字段
//@property (nonatomic, copy) NSString *phone;//电话号码
@property (nonatomic, copy) NSString *houseDate;//准备装修时间
//@property (nonatomic, assign) NSInteger isRead;//是否已读


//号码通
//@property (copy, nonatomic) NSString *calVip;


// 判断是新数据
@property (nonatomic, copy) NSString *isNewData; // 1新数据  0 老数据


// 新数据字段
// 接单公司companyName
//@property (nonatomic, copy) NSString *companyName;
// 装修地区
@property (nonatomic, copy) NSString *cityName;

// 预算
@property (nonatomic, strong) NSString *budget;
// 个性化需求
@property (nonatomic, strong) NSString *individualization;
// 色调
@property (nonatomic, strong) NSString *tone;
// 喊装修ID
//@property (nonatomic, assign) NSInteger decorationId;
// 家庭结构
@property (nonatomic, strong) NSString *familyStructure;
// 面积  换成string类型的了
//@property (nonatomic, assign) double area;
@property (nonatomic, strong) NSString *area;
// 风格
@property (nonatomic, strong) NSString *style;
// 姓名
//@property (nonatomic, strong) NSString *fullName;
// 公司ID
//@property (nonatomic, assign) NSInteger companyId;
// 装修区域省编号
@property (nonatomic, assign) NSInteger province;
// 装修区域市编号
@property (nonatomic, assign) NSInteger city;
// 装修区域区县编号
@property (nonatomic, assign) NSInteger county;

// 户型图地址数组
@property (nonatomic, strong) NSArray<ImageObject *> *imgList;
// 数据来源
//@property (nonatomic, strong) NSString *source;
//@property (nonatomic, strong) NSString *addTime;

@end

@interface ImageObject: NSObject
// 户型图
@property (nonatomic, strong) NSString *picUrl;
@end
