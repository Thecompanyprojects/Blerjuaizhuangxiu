//
//  STYNewProductCouponController.h
//  iDecoration
//
//  Created by sty on 2018/2/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^RefreshBlock)();
@interface STYNewProductCouponController : SNViewController
@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, assign) BOOL isEdit;//是否是编辑 no：新建。yes：编辑
@property (nonatomic, assign) BOOL isHaveRecive;//是否有人领过
@property (nonatomic, copy) NSString *couponId;//礼品券id
@property (nonatomic, copy) NSString *CouponNameStr;//名称
@property (nonatomic, copy) NSString *CouponNumStr;//礼品总数
@property (nonatomic, copy) NSString *CouponFaceValueStr;//礼品
@property (nonatomic, copy) NSString *CouponStartTimeStr;//生效时间
@property (nonatomic, copy) NSString *CouponEndTimeStr;//过期时间
@property (nonatomic, copy) NSString *CouponScopeStr;//领取范围
@property (nonatomic, copy) NSString *CouponAddressStr;//领取地点
@property (nonatomic, assign) double lantitude; // 地址经纬度
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *CouponRemarks;//备注

@property (copy, nonatomic) RefreshBlock block;
@property (nonatomic,copy) NSString *companyName;//公司名称
@property (nonatomic, strong) NSMutableArray *couponArray;

@property (nonatomic, assign) BOOL ischoose;//是否有权限
@end
