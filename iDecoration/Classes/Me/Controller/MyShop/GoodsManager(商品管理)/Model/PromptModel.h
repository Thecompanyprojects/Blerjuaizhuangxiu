//
//  PromptModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PromptGoodsList;
@class PromptMerchandiesList;


@interface PromptModel : NSObject

// 活动id
@property (nonatomic, copy) NSString *promptID;
// 活动名称
@property (nonatomic, copy) NSString *activityName;
// 活动类型  活动类型1、全店满送 2、商品满送 3、全店满减 4、商品满减 5、全店优惠券 6、商品优惠券 7、套餐
@property (nonatomic, copy) NSString *activityType;

@property (nonatomic, strong) NSString *activityTypeString;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;
// 活动范围 活动范围（0.全店1.部分商品）
@property (nonatomic, copy) NSString *activityRange;

@property (nonatomic, copy) NSString *consumeMoney;

@property (nonatomic, copy) NSString *discountMoney;

@property (nonatomic, copy) NSString *makeCondition;
// 套餐价格
@property (nonatomic, copy) NSString *tcPrice;

@property (nonatomic, copy) NSString *merchantId;


@property (nonatomic, strong) NSArray<PromptGoodsList *> *goodsList;

//@property (nonatomic, strong) NSArray<PromptMerchandiesList *> *merchandiesList;

@end



@interface PromptGoodsList : NSObject
//商品id
@property (nonatomic, copy) NSString *goodsId;
//商品封面图
@property (nonatomic, copy) NSString *goodsDisplay;
@end

//@interface PromptMerchandiesList : NSObject
////商品id
//@property (nonatomic, copy) NSString *merchandiesId;
////商品封面图
//@property (nonatomic, copy) NSString *merchandiesDisplay;
//@end

