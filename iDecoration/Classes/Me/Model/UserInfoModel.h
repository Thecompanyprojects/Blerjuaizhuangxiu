//
//  UserInfoModel.h
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject




@property (nonatomic, copy) NSString *wxCode;//微信唯一标识
@property (nonatomic, copy) NSString *phone;//手机号码
@property (nonatomic, assign) NSInteger roleTypeId;//职位ID
@property (nonatomic, assign) NSInteger gender;//性别 （0：女，1：男）
@property (nonatomic, copy) NSString *password;//密码
@property (nonatomic, copy) NSString *userName;//用户名(这个不用)
@property (nonatomic, copy) NSString *trueName;//真实姓名(用这个 上边那个没用)
@property (nonatomic, copy) NSString *registJob;//职位类别父级Id
@property (nonatomic, copy) NSString *jobName;//职位名称
@property (nonatomic, assign) NSInteger agencyId;//用户ID
@property (nonatomic, copy) NSString *photo;//默认头像
@property (nonatomic, copy) NSString *weixin;//微信
@property (nonatomic, copy) NSString *userLogo;//用户头像
@property (nonatomic, copy) NSString *showPhone;//是否展示手机号 0 不展示 1展示

@property (nonatomic, copy) NSString *address;//个人详细地址
@property (nonatomic, copy) NSString *longitude;//个人详细地址 经度
@property (nonatomic, copy) NSString *latitude;//个人详细地址 纬度

@property (nonatomic, copy) NSString *email;//邮箱
@property (nonatomic, copy) NSString *indu;//个人简介
@property (nonatomic, copy) NSString *wxQrcode;//微信二维码
//@property (nonatomic, copy) NSString *workingDate;//从业时间
@property (nonatomic, copy) NSString *comment;//备注
@property (nonatomic, assign) CGFloat provinceId;//所在地省份
@property (nonatomic, assign) CGFloat cityId;//所在地市区
@property (nonatomic, assign) CGFloat countyId;//所在地区县
@property (nonatomic, assign) CGFloat hometownProvinceId;//籍贯省份
@property (nonatomic, assign) CGFloat hometownCityId;//籍贯城市
@property (nonatomic, assign) CGFloat hometownCountyId;//籍贯区县
@property (nonatomic, copy) NSString *homeTownName;//籍贯
//@property (nonatomic, copy) NSString *addressStr;//所在地
//@property (nonatomic, copy) NSString *nativeStr;//籍贯
@property (nonatomic, copy) NSString *merchantId;//我的店铺id
@property (assign, nonatomic) NSInteger agencyBirthday;// 生日(时间戳)
@property (assign, nonatomic) NSInteger workingDate;//从业时间
@property (copy, nonatomic) NSString *agencySchool;// 毕业院校
@property (copy, nonatomic) NSString *companyJob;// 公司职位
@property (copy, nonatomic) NSString *company;// 公司名称

@property (strong, nonatomic) NSString *roleType;//职业类别
@property(nonatomic,copy)NSString *huanXinId;  //环信的用户名
@property(nonatomic,copy)NSString *huanXinPassword; //环信的密码
@property (copy, nonatomic) NSString *eliteDesignId;//精英推荐Id（0没有，大于0有故事）

// 是否有名片
@property (copy, nonatomic) NSString *isCard;




@end
