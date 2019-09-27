//
//  goodsModel.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsModel : NSObject

//图片链接
@property(nonatomic,copy)NSString *display;

//企业页面商品ID
@property(nonatomic,copy)NSString *merchandId;


@property(nonatomic,copy)NSString *merchandiesId;   // 商品列表 企业商品ID
//商品名称
@property(nonatomic,copy)NSString *name;

//商品的价格
@property(nonatomic,copy)NSString *price;

// 商品ID
@property (nonatomic, assign) NSInteger goodsId;
// 商家Id
@property (nonatomic, copy) NSString *merchantId;
// 创建时间
@property (nonatomic, assign) long createDate;

@end
