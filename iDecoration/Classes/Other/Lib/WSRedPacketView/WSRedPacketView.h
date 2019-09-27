//
//  WSRedPacketView.h
//  Lottery
//
//  Created by tank on 2017/12/16.
//  Copyright © 2017年 tank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSRewardConfig.h"

typedef void(^WSCancelBlock)(void);
typedef void(^WSFinishBlock)(float money);

typedef void(^WSShwoVerifBlock)(void);

@interface WSRedPacketView : UIViewController


@property (nonatomic, copy) NSString *couponId;//代金券id
@property (nonatomic, copy) NSString *giftCouponId;//礼品券id

@property (nonatomic, assign)double longitude;//经度
@property (nonatomic, assign)double latitude;//纬度



@property (nonatomic, copy) NSString *companyNameStr;//公司名称
@property (nonatomic, copy) NSString *companyLogoStr;//公司logo
@property (nonatomic, copy) NSString *priceStr;//代金券价格
@property (nonatomic, copy) NSString *couponNameStr;//礼品券名称
@property (nonatomic, copy) NSString *faceImgStr;//礼品券封面图

@property (nonatomic, copy) NSString *couponCode;//代金券验证码
@property (nonatomic, copy) NSString *productCode;//礼品券验证码

@property (nonatomic, copy) NSString *couponCcId;//代金券返回领取主键
@property (nonatomic, copy) NSString *productCcId;//礼品券返回领取主键



@property (nonatomic,assign) NSInteger couponType;//1：只有代金券 2:只有礼品券 3:都有
@property (nonatomic, assign) NSInteger modifyTag;//1:当前验证的是代金券。2:验证的是礼品券

@property (nonatomic, assign) BOOL isHaveOpen;//马上领取按钮是否已经点击
@property (nonatomic, assign) BOOL isHaveModify;//是否已经验证过

//+ (instancetype)showRedPackerWithData:(WSRewardConfig *)data
//                          cancelBlock:(WSCancelBlock)cancelBlock
//                          finishBlock:(WSFinishBlock)finishBlock;

-(instancetype)initRedPacker;

@property (nonatomic, copy) void(^lookBlock)(NSDictionary *dict);
@property (nonatomic, assign) NSInteger tag; //1:当前是代金券。2:当前是礼品券

@end
