//
//  HomeCommodyList.h
//  iDecoration
//
//  Created by john wall on 2018/10/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCommodyList : NSObject
//longitube true string 经度
//distance false string 距离(距离查询时返回)
//latitude true string 纬度
//locationStr true string 区县
//companyAddress true string 公司地址
//recommendVip true number 是否是成长计划会员(0:不是,1:是)
//typeName true string 公司名称
//appVip true number 是否是黄页会员(0:不是,1:是)
//typeLogo true string 公司logo
//serviceScope true string 服务范围
//id true number 公司id
//browse true number 浏览量
//flower false number 鲜花数,好评(好评/信用查询时返回)
//banner false number 锦旗数,信用(好评/信用查询时返回)
//caseTotla false number 案例数(案例查询时返回)
//praiseTotal false number 商品数量(商品查询时返回)
//companyIntroduction true string 公司简介
//status true number 2:已认证



@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *flower;
@property (strong, nonatomic) NSString *banner;
//@property (strong, nonatomic) NSString *likeNumbers;
@property (strong, nonatomic) NSString *browse;
@property (strong, nonatomic) NSString *caseTotlal;
@property (strong, nonatomic) NSString *praiseTotal;
@property (strong, nonatomic) NSString *longitube;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *locationStr;

@property (strong, nonatomic) NSString *recommendVip;
@property (strong, nonatomic) NSString *appVip;

@property (strong, nonatomic) NSString *typeName;
@property (strong, nonatomic) NSString *typeLogo;
@property (strong, nonatomic) NSString *companyAddress;
@property (strong, nonatomic) NSString *companyIntroduction;
@property (strong, nonatomic) NSString *serviceScope;




@end
