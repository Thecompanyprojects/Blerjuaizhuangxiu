//
//  GoodsListModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ActivityListModel;

@interface GoodsListModel : NSObject

// 是否 是 企业商品列表 分类 列表
@property (nonatomic, assign) BOOL isYellowPageClassifyLayout;

// 商品id
@property (nonatomic, assign) NSInteger goodsID;
// 商品名字
@property (nonatomic, copy) NSString *name;
// 封面 以前用dispaly。使用时也是用的dispaly 现在接口中是faceImg   在.m文件中已经把faceImg映射到display
@property (nonatomic, copy) NSString *display;
@property (nonatomic, copy) NSString *faceImg;

// 价格
@property (nonatomic, copy) NSString *price;
// 创建时间
@property (nonatomic, copy) NSString *createDate;
// 店铺id
@property (nonatomic, assign) NSInteger merchantId;
// 内外网显示
@property (nonatomic, assign) NSInteger isDisplay;
// 浏览量
@property (nonatomic, assign) NSInteger scanCount;
// 点赞量
@property (nonatomic, assign) NSInteger likeNumber;
// 排序
@property (nonatomic, assign) NSInteger sort;
// 音频地址
@property (nonatomic, copy) NSString *musicUrl;
// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
// 规格参数
@property (nonatomic, copy) NSString *standard;
// 类别id
@property (nonatomic, assign) NSInteger categoryId;
// 是否促销（0.否，1.是）
@property (nonatomic, assign) NSInteger isCheap;
// 是否推广（0.否，1.是）
@property (nonatomic, assign) NSInteger isSpread;
// 商品收藏数量
@property (nonatomic, assign) NSInteger collectionNum;

@property (nonatomic, assign) NSInteger merchandiesId;//商品id（主材日志添加商品时使用）

@property (nonatomic, strong) NSArray<ActivityListModel *> *activityList;

@end

@interface ActivityListModel: NSObject
@property (nonatomic, assign) NSInteger activityID;
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *activityType;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *makeCondition;
@property (nonatomic, copy) NSString *receiveStatus; // 领取状态0.未领取、大于零已领取
@property (nonatomic, copy) NSString *discountMoney; // 券金额
@end
