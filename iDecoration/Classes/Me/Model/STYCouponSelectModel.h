//
//  STYCouponSelectModel.h
//  iDecoration
//
//  Created by sty on 2018/2/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STYCouponSelectModel : NSObject


@property (nonatomic, copy) NSString *faceImg;//封面图

@property (nonatomic, copy) NSString *musicName;
@property (nonatomic, copy) NSString *musicUrl;


@property (nonatomic, copy) NSString *params;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *videoImg;
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, copy) NSString *viewImg;
@property (nonatomic, copy) NSString *viewUrl;

@property (nonatomic, copy) NSString *ccgId;//关联主键 大于0表示选中
@property (nonatomic, copy) NSString *displayImg;
@property (nonatomic, copy) NSString *musicAutoplay;
@property (nonatomic, copy) NSString *viewName;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *numbers;//数量
@property (nonatomic, copy) NSString *giftName;//礼品名称
@property (nonatomic, copy) NSString *giftId;
@property (nonatomic, copy) NSString *companyId;


@property (nonatomic, strong) NSArray *details;
@end
