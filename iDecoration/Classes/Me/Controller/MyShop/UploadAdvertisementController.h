//
//  UploadAdvertisementController.h
//  iDecoration
//
//  Created by zuxi li on 2017/7/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface UploadAdvertisementController : SNViewController
@property (nonatomic, strong) NSString *companyID;
@property (nonatomic, assign) BOOL isShop;
// 是否有图片回调 0 没有有  非0： 有图
@property (nonatomic, copy) void(^adBlock)(NSInteger hasImage);
// 合作企业的回调
@property (nonatomic, copy) void(^backBlock)(void);
@end
