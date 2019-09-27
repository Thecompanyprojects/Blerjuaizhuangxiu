//
//  NSObject+CompressImage.h
//  iDecoration
//
//  Created by zuxi li on 2017/7/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CompressImage)

/**
 压缩图片

 @param myimage 被压缩的图片
 @return 图片的二进制数据
 */
+ (NSData *)imageData:(UIImage *)myimage;


/**
 压缩图片

 @param myImage 被压缩的图片
 @return 返回的图片
 */
+ (UIImage *)imageCompressFromImage:(UIImage *)myImage;


/**
 消息列表 前三次进入弹出左滑提示

 @param controllerName 出现提示的控制器名称
 */
+ (void)promptWithControllerName:(NSString *)controllerName;

/**
 压缩图片的宽高

 @param image 要压缩的图片
 @param newSize  压缩到多大
 @return 返回压缩好图片的二级制数据
 */
+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;


/**
 将长方形的图片改成正方形

 @param image 图片
 @param mCGRect 图片大小
 @param centerBool 是否设置中心点 如若centerBool为Yes则是由中心点取mCGRect范围的图片
 @return 图片
 */
+ (UIImage*)getSubImage:(UIImage*)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;
    

/**
 根据状态条获取当前网络状态

 @return 网络状态
 */
+ (NSString *)networkingStatesFromStatebar;


/**
 根据公司ID统计公司分享的数量 为后台统计数量服务

 @param companyId 公司id
 */
+ (void)companyShareStatisticsWithConpanyId:(NSString *)companyId;

/**
 根据工地ID统计工地分享的数量 为后台统计数量服务
 
 @param constructionId 工地Id
 */
+ (void)contructionShareStatisticsWithConstructionId:(NSString *)constructionId;

/**
 根据商品ID统计商品分享的数量 为后台统计数量服务
 
 @param merchandiesId 商品id
 */
+ (void)goodsShareStatisticsWithMerchandiesId:(NSString *)merchandiesId;

/**
 根据公司ID统计喊装修浏览数量 为后台统计数量服务
 
 @param companyId 公司id
 */
+ (void)needDecorationStatisticsWithConpanyId:(NSString *)companyId;

/**
 上传图片

 @param imgArray 要上传的图片数组
 @param completion 上传完成回调  返回图片链接数组
 */
+ (void)uploadImgWith:(NSArray *)imgArray completion:(void(^)(NSArray * imageURLArray))completion;


// 获取本地视频的第一张图
+ (UIImage *)getImageFromLocalVideoPath:(NSString *)videoURL;

/**
 比较两个时间的大小

 @param date01 1
 @param date02 2
 @return /date02比date01大  1  date02比date01小 -1 date02=date01  返回0
 */
+ (int)compareDate:(NSString*)date01 littlewithDate:(NSString*)date02;

/**
 通过时间秒获取时间字符串

 @param timerInterval 距离1970年的时间间隔
 @param format 字符串时间格式
 @return 字符串时间
 */
+ (NSString*)timeStringFromTimeIntervalString:(NSTimeInterval)timerInterval WithFromatter:(NSString *)format;


/**
 获取验证码 倒计时

 @param s 倒计时秒数
 @param btn 获取验证码按钮
 */
+ (void) timelessWithSecond:(NSInteger)s button:(UIButton *)btn ;
@end
