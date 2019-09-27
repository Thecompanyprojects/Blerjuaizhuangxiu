//
//  STYNewCashCouponController.h
//  iDecoration
//
//  Created by sty on 2018/2/5.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^RefreshBlock)();
@interface STYNewCashCouponController : SNViewController
@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) RefreshBlock block;

@property (nonatomic, assign) BOOL isEdit;//是否是编辑 no：新建。yes：编辑
@property (nonatomic, assign) BOOL isHaveRecive;//是否有人领过
@property (nonatomic, copy) NSString *CouponId;//id
@property (nonatomic, copy) NSString *CouponType;//代金券类型(0：普通代金券 1:手气代金券)
@property (nonatomic, copy) NSString *CouponNameStr;//名称
@property (nonatomic, copy) NSString *CouponNumStr;//发行数量
@property (nonatomic, copy) NSString *CouponFaceValueStr;//面值
@property (nonatomic, copy) NSString *CouponStartTimeStr;//生效时间
@property (nonatomic, copy) NSString *CouponEndTimeStr;//过期时间
@property (nonatomic, copy) NSString *CouponScopeStr;//领取范围
@property (nonatomic, copy) NSString *CouponAddressStr;//领取地点
@property (nonatomic, assign) double lantitude; // 地址经纬度
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *CouponRemarks;//备注

@property (nonatomic,copy)  NSString *companyName;
//@property (nonatomic, assign) NSInteger cashType;// 0:普通红包，1:拼手气红包
@property (nonatomic, assign) BOOL ischoose;//是否有权限
@end
