//
//  goodsModel.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "goodsModel.h"

@implementation goodsModel
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//}


+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"goodsId":@"id", @"display": @"faceImg"};
   
}


- (void)setGoodsId:(NSInteger)goodsId {
    self.merchandiesId = [NSString stringWithFormat:@"%ld", goodsId];
    _goodsId = goodsId;
}
@end
