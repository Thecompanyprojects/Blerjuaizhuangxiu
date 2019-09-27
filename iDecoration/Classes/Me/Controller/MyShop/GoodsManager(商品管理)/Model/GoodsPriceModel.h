//
//  GoodsPriceModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsPriceModel : NSObject


+ (instancetype)newModel;

//名称
@property (nonatomic, strong) NSString *name;
//价格
@property (nonatomic, strong) NSString *price;
//单位
@property (nonatomic, strong) NSString *unit;
//库存
@property (nonatomic, strong) NSString *num;
//图片
@property (nonatomic, strong) UIImage *image;
//图片地址
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, strong) NSString *flowerNumber;

@property (nonatomic, strong) NSString *pennantNumber;


@end
