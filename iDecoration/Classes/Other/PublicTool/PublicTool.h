//
//  PublicTool.h
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface PublicTool : NSObject

+(PublicTool*)defaultTool;

#pragma mark -- 校验手机号
-(BOOL)publicToolsCheckTelNumber:(NSString*)telNumber;

#pragma mark -- 为textField添加leftView
-(void)publicToolsAddLeftViewWithTextField:(UITextField*)textField;

#pragma mark -- 弹出确定提示
-(void)publicToolsSureAlertInfo:(NSString *)info controller:(UIViewController *)controller;

#pragma mark -- 检测字符串是否英文及数字组合
-(BOOL)publicToolsCheckStrIsWordsWithNumber:(NSString*)str;

#pragma mark -- 提示自动消失
-(void)publicToolsHUDStr:(NSString *)HUDStr controller:(UIViewController*)controller sleep:(CGFloat)second;

#pragma mark -- 得到保存用户信息的Model
-(UserInfoModel*)publicToolsGetUserInfoModelFromDict;

#pragma mark -- 判断用户是否登陆
-(BOOL)publicToolsJudgeIsLogined;

#pragma mark -- 校验身份证号
- (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp;
-(NSString*)getDateFormatStrFromTimeStampWithSeconds:(NSString*)timeStamp;
- (NSString*)getDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp;

- (NSString*)newgetDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp;
@end
