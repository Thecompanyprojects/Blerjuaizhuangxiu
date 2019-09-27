//
//  MyBeautifulArtShowController.h
//  iDecoration
//
//  Created by sty on 2017/11/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface MyBeautifulArtShowController : SNViewController
@property (nonatomic, copy) void(^BeautifulArtShowBlock)();
@property(nonatomic,assign)NSInteger designsId;//活动主体信息
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIWebView *webView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;

@property (nonatomic,assign) NSInteger activityType;// 2:美文，3：活动
@property(nonatomic,copy)NSString *activityId;//活动id
@property (copy, nonatomic) NSString *url;

@property (nonatomic, copy) NSString *companyId; // 公司ID
@property(nonatomic,copy)NSString *designTitle;//主标题
@property(nonatomic,copy)NSString *designSubTitle;//副标题
@property(nonatomic,copy)NSString *coverMap;//封面

@property (nonatomic, assign) NSInteger meCalVipTag;//0:该人员未开通个人计算器会员  1:开通

@property (nonatomic, copy) NSString *activityAddress;
@property (nonatomic, copy) NSString *activityTime;

@property (nonatomic, assign) NSInteger musicStyle;//0:自动播放 1:点击播放
@property (nonatomic, assign) NSInteger order;//图文显示位置（0：图上字下，1：图下字上）
@property (nonatomic, copy) NSString *templateStr;//模版地址

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
- (id)toArrayOrNSDictionary:(NSData *)jsonData;
- (void)addBottomShareView;
@end
