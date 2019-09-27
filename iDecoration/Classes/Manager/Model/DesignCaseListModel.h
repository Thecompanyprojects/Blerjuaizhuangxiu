//
//  DesignCaseListModel.h
//  iDecoration
//
//  Created by Apple on 2017/8/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignCaseListModel : NSObject
@property (nonatomic, assign) NSInteger sort;//排序使用
@property (nonatomic, assign) NSInteger detailsId;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *content;//不含html5
@property (nonatomic, copy) NSString *htmlContent;//含html5
@property (nonatomic, copy) NSString *link;//链接
@property (nonatomic, copy) NSString *linkDescribe;//链接描述

@property (nonatomic, copy) NSString *videoUrl;//视频的url
@property (nonatomic, copy) NSString *currencyUrl;//通用地址
@end
