//
//  UnionActivityListModel.h
//  iDecoration
//
//  Created by sty on 2017/10/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnionActivityListModel : NSObject
@property(nonatomic,copy)NSString *startTime;//活动开始时间
@property(nonatomic,copy)NSString *designTitle;//活动标题
@property(nonatomic,copy)NSString *activityPerson;//活动人数（0：不限制）
@property(nonatomic,copy)NSString *activityStatus;//活动状态（0：报名中，1：待审核，2：审核通过，3：活动结束，4：活动进行中）
@property(nonatomic,copy)NSString *endTime;//活动结束时间
@property(nonatomic,copy)NSString *personNum;//已报名人数
@property(nonatomic,copy)NSString *designsId;//活动主体信息
@property(nonatomic,copy)NSString *activityId;//活动id

@property(nonatomic,copy)NSString *readNum;//浏览量
@property(nonatomic,copy)NSString *shareNumber;//分享数
@property(nonatomic,copy)NSString *collectionNum;//收藏量

@property(nonatomic,copy)NSString *designSubTitle;//副标题
@property(nonatomic,copy)NSString *coverMap;//封面
@property(nonatomic,copy)NSString *agencysId;//创建活动人员id

@property(nonatomic,copy)NSString *companyLandLine;//座机号
@property(nonatomic,copy)NSString *companyPhone;//手机号
// 是否是线上活动
@property (nonatomic, copy) NSString *activityPlace; // 0:线下，1：线上
@property (nonatomic, copy) NSString *activityAddress; // 活动地址
@property (nonatomic, assign) NSInteger isStop;// 0:未关闭报名 1:已关闭报名
@property (nonatomic, assign) NSInteger topId;// 置顶id（为0时该活动未置顶）

@property(nonatomic,assign)NSInteger companyAgnecysId;//是否是创建公司的经理（大于0是）

@property (nonatomic, assign) NSInteger musicPlay;  // 音乐播放方式(0：自动播放，1：点击播放)
@end
