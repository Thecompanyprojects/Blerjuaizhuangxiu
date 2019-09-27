//
//  STYProductCouponDetailController.h
//  iDecoration
//
//  Created by sty on 2018/3/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface STYProductCouponDetailController : SNViewController

@property (nonatomic, assign) NSInteger couponType; //1:代金券 2:礼品券

@property (nonatomic, assign) BOOL isChangeTime;//no:需要转时间。yes：不需要转时间
//@property(nonatomic, copy) NSString *couponId;
@property(nonatomic, copy) NSString *giftId;
@property (nonatomic, copy) NSString *couponAddress;//领取地点
@property (nonatomic, copy) NSString *couponCode;//兑换码
@property (nonatomic, copy) NSString *startTime;//
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *remark;//备注

@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyName;

@end
