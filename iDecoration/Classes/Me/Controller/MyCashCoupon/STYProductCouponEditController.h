//
//  STYProductCouponEditController.h
//  iDecoration
//
//  Created by sty on 2018/2/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"



@interface STYProductCouponEditController : SNViewController
@property (nonatomic, strong) NSMutableArray *orialArray;//原始数组
@property (nonatomic, strong) NSMutableArray *dataArray;//临时数组

@property (nonatomic, strong) NSMutableArray *paramArray;//参数数组

@property (nonatomic, copy) void(^block)();

@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, copy) NSString *faceImg;//封面图片
@property (nonatomic, copy) NSString *displayImg;//多张图片的字符串
@property (nonatomic, strong) NSMutableArray *bannerImgArray;//轮播图（包括视频图片和5张封面图）
@property (nonatomic, strong) NSMutableArray *coverImgArray;//仅仅是5张封面图

@property (nonatomic, copy) NSString *musicUrl;//音乐地址
@property (nonatomic, copy) NSString *musicName;//音乐名称
@property (nonatomic, assign) NSInteger musicStyle;//0:自动播放 1:点击播放

@property (nonatomic, copy) NSString *videoImgUrl;//视频第一针图片
@property (nonatomic, copy) NSString *videoUrl;//视频地址
//@property (nonatomic, copy) NSString *videoName;//视频名称

@property (nonatomic, copy) NSString *coverImgStr;//全景封面
@property (nonatomic, copy) NSString *nameStr;//全景名称
@property (nonatomic, copy) NSString *linkUrl;//全景链接


@property (nonatomic, copy) NSString *giftId;//礼品主键
@property (nonatomic, copy) NSString *productNameStr;//礼品名称
@property (nonatomic, copy) NSString *productParamStr;//礼品参数
@property (nonatomic, copy) NSString *productPriceStr;//市场参考价
@end
