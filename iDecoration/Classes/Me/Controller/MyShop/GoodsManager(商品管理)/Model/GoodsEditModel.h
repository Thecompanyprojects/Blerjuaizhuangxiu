//
//  GoodsEditModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsEditModel : NSObject

+ (instancetype)newModel;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSString *videoUrl;

/*
 @property (nonatomic, assign) NSInteger sort;//排序使用
 @property (nonatomic, assign) NSInteger detailsId;
 @property (nonatomic, copy) NSString *imgUrl;
 @property (nonatomic, copy) NSString *content;//不含html5
 @property (nonatomic, copy) NSString *htmlContent;//含html5
 @property (nonatomic, copy) NSString *link;//链接
 @property (nonatomic, copy) NSString *linkDescribe;//链接描述
 */

@end
