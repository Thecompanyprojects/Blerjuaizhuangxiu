//
//  GoodsParamterModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsParamterModel : NSObject

+ (instancetype)newModel;

// 参数名称
@property (nonatomic, strong) NSString *name;
// 参数描述
@property (nonatomic, strong) NSString *describ;


@end
