//
//  ZCHCouponModel.h
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHCouponModel : NSObject

//couponId = 25;
//couponName = "\U5475\U5475\U54d2";
//couponNo = kb0wmx3454;
//endDate = 1517500800000;
//exchangeAddress = "\U54c8\U54c8";
//expired = 0;
//merchandName = "";
//merchandPhoto = "";
//numbers = 5;
//price = 7;
//remainNumbers = 5;
//startDate = 1514822400000;
//type = 0;


// 是否过期
@property (nonatomic, copy) NSString *expired; //0:过期 不等0:没过期
// 代金券名字
@property (nonatomic, copy) NSString *couponName;
// 代金券类型(0：普通代金券 1:手气代金券 2:礼品券)
@property (nonatomic, copy) NSString *type;
// ID
@property (nonatomic, copy) NSString *couponId;
// 开始日期
@property (nonatomic, copy) NSString *startDate;
// 结束日期
@property (nonatomic, copy) NSString *endDate;
// 商品名称
@property (nonatomic, copy) NSString *merchandName;
// 编号
@property (nonatomic, copy) NSString *couponNo;
// 商品图片
@property (nonatomic, copy) NSString *merchandPhoto;
// 公司名字
@property (nonatomic, copy) NSString *companyName;
// logo
@property (nonatomic, copy) NSString *companyLogo;
//vip
@property (nonatomic, copy) NSString *calVip;
// 剩余数量(等于发行数量表示没有被领取过）
@property (nonatomic, copy) NSString *remainNumbers;
// 发行数量
@property (nonatomic, copy) NSString *numbers;
// 兑换地址
@property (nonatomic, copy) NSString *exchangeAddress;
// 代金券金额
@property (copy, nonatomic) NSString *price;

// 备注
@property (copy, nonatomic) NSString *remark;

// 领取范围
@property (copy, nonatomic) NSString *exchangeScope;


// 兑换码
@property (copy, nonatomic) NSString *receiveCode;

//经纬度
@property (nonatomic, copy) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;

@property (assign, nonatomic) BOOL isSelect;

// 礼品id
@property (nonatomic, copy) NSString *giftId;
// 礼品名称
@property (nonatomic, copy) NSString *giftName;
// 礼品封面图
@property (nonatomic, copy) NSString *faceImg;
// 金额(扫码后展示使用)
@property (copy, nonatomic) NSString *money;
// 用在我的代金券中的(获取详情)
@property (copy, nonatomic) NSString *companyId;
// 删除用的(领券的时候也会使用)
@property (copy, nonatomic) NSString *ccId;


@end
