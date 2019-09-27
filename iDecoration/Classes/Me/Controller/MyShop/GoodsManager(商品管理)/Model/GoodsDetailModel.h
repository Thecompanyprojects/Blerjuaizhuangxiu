//
//  GoodsDetailModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GoodsParamterModel.h"
#import "GoodsPriceModel.h"


@class ActivityListModel;

@class List;

@interface GoodsDetailModel : NSObject
// 商品id
@property (nonatomic, assign) NSInteger goodsID;
// 商品名称
@property (nonatomic, strong) NSString *name;


// 店铺id
@property (nonatomic, assign) NSInteger merchantId;
// 价格
@property (nonatomic, copy) NSString *price;
// 添加时间
@property (nonatomic, assign) NSInteger createDate;
// 内外网展示0内网1外网2内外网
@property (nonatomic, assign) NSInteger isDisplay;
// 店铺名称
@property (nonatomic, strong) NSString *companyName;
// 店铺logo
@property (nonatomic, strong) NSString *companyLogo;
// 店铺地址
@property (nonatomic, strong) NSString *companyAddress;
// 店铺座机
@property (nonatomic, strong) NSString *companyPhone;
// 店铺手机
@property (nonatomic, strong) NSString *companyLandline;
// 店铺浏览量
@property (nonatomic, assign) NSInteger browse;
// 店铺展现量
@property (nonatomic, assign) NSInteger displayNumbers;
// 商品浏览量
@property (nonatomic, assign) NSInteger scanCount;
// 商品点赞量
@property (nonatomic, assign) NSInteger likeNumber;
// 商品参数
@property (nonatomic, strong) NSString *standard;
// 音频地址
@property (nonatomic, strong) NSString *musicUrl;
// 音乐名字
@property (nonatomic, strong) NSString *musicName;
// 视频地址
@property (nonatomic, strong) NSString *videoUrl;
// 视频图片地址
@property (nonatomic, strong) NSString *videoImg;
// 商品全景展示链接
@property (nonatomic, strong) NSString *viewUrl;
// 全景名字
@property (nonatomic, strong) NSString *viewName;
// 全景图片
@property (nonatomic, strong) NSString *viewImg;

// 是否来同企业网会员（0.未开通，1.已开通）
@property (nonatomic, strong) NSString *yellowVip;
// 该商品收藏数量
@property (nonatomic, strong) NSString *collectionNum;
// collectionType 是否收藏（0，未收藏、1，已收藏）
@property (nonatomic, strong) NSString *collectionType;
// 商品MV展示链接
@property (nonatomic, strong) NSString *mvUrl;
// 商品封面图  头部所有图片包括视频封面图
@property (nonatomic, strong) NSArray *displayList;

// 商品分类id
@property (nonatomic, assign) NSUInteger categoryId;
// 商品分类名称
@property (nonatomic, strong) NSString *categoryName;
// 简短说明
@property (nonatomic, strong) NSString *cutLine;
// 音乐是否自动播放（0：不自动播放，1：自动播放）
@property (nonatomic, assign) NSInteger isCheap;
// 详情列表
@property (nonatomic, strong) NSArray<List *>* list;

@property (nonatomic, strong) NSArray<ActivityListModel *> *activityList;

// 参数
@property (nonatomic, strong) NSArray<GoodsParamterModel *> *standardList;
// 服务
@property (nonatomic, strong) NSArray<GoodsParamterModel *> *serviceList;
// 价格
@property (nonatomic, strong) NSArray<GoodsPriceModel *> *priceTypeList;

// 是否置顶 是否置顶（0.否，1.是）
@property (nonatomic, copy) NSString *isYellow;

@property (nonatomic, copy) NSString *recommend;//是否推送到同城
@end


@interface List: NSObject
// 想=详情id
@property (nonatomic, assign) NSInteger instructionId;
// 内容
@property (nonatomic, strong) NSString *content;
// 图片路径
@property (nonatomic, strong) NSString *imgUrl;
// 商品id
@property (nonatomic, assign) NSInteger merchandiesId;
// mv地址
@property (nonatomic, strong) NSString *mvUrl;

@end


// 评论
@interface CommmentModel: NSObject
// 小区名称
@property (nonatomic, strong) NSString *areaName;
// 评论内容
@property (nonatomic, strong) NSString *content;
// 综合评价
@property (nonatomic, strong) NSString *sumGrade;
// 业主名字
@property (nonatomic, strong) NSString *trueName;
// 业主头像
@property (nonatomic, strong) NSString *photo;
//工地id
@property (nonatomic, assign) NSInteger constructionId;
// 分享标题
@property (nonatomic, strong) NSString *shareTitle;
// 工地封面图
@property (nonatomic, strong) NSString *frontPage;
//工地类型
@property (nonatomic, copy) NSString *constructionType;
@end

