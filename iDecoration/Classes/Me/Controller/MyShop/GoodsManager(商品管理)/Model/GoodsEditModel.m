//
//  GoodsEditModel.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsEditModel.h"

@implementation GoodsEditModel

+ (instancetype)newModel {
    GoodsEditModel *model = [GoodsEditModel new];
    model.image = nil;
    model.contentText = @"";
    model.imgUrl = @"";
    model.videoUrl = @"";
    return model;
}
@end
