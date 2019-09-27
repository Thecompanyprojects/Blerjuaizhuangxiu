//
//  GoodsEditViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
@class ClassifyModel;

@interface GoodsEditViewController : SNViewController
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, assign) NSInteger agencJob; // 职位ID
// 是否是执行经理
@property (nonatomic,assign) BOOL implement;   // 总经理、执行经理添加的商品参数名可以应用于整个商品参数

@property (nonatomic, strong) NSArray *originImageArray;
@property (nonatomic, strong) NSArray *originImageURLArray;



@property (nonatomic, strong) NSMutableArray *dataArray;// 想情数据 详情model数组
@property (nonatomic, strong) NSString *musicUrl; // 音乐链接
@property (nonatomic, strong) NSString *musicName; // 音乐名称

@property (nonatomic, strong) NSMutableArray *adImgURLArray; // 轮播图链接 5张  不包括视频的

@property (nonatomic, strong) NSMutableArray *adImageArray; // 轮播图图片数组 包括视频的

@property (nonatomic, strong) NSString *videoUrl; // 视频地址 头部的
@property (nonatomic, strong) NSString *videoImageUrl; // 视频 的图片地址 头部的
@property (nonatomic, strong) UIImage *videoImag; // 视频 的图片 头部的


@property (nonatomic, copy) NSString *coverImgStr;//全景封面
@property (nonatomic, copy) NSString *nameStr;//全景名称
@property (nonatomic, copy) NSString *linkUrl;//全景链接

@property (nonatomic, strong) NSString *goodsName;// 商品名称
@property (nonatomic, strong) NSString *price;// 商品价格
@property (nonatomic, strong) NSString *standard;// 商品参数
@property (nonatomic, strong) ClassifyModel *classifyModel; // 商品分组

@property (nonatomic, assign) BOOL isFromDetail; // YES  详情页跳转来  编辑商品    NO 默认  新建商品
@property (nonatomic, assign) NSInteger goodsID; // 商品ID

@property (nonatomic, strong) NSMutableArray *listArray; // 商品参数数组
// 服务承若数组
@property (nonatomic, strong) NSMutableArray *serviceArray;
// 价格数组
@property (nonatomic, strong) NSMutableArray *priceArray;
@property (nonatomic, strong) NSString *moreExplain; // 补充说明
@property (nonatomic, assign) NSInteger musicStyle;//1:自动播放 0:点击播放

@property (nonatomic, copy) void(^EditingCompletionBlock)();

@end
