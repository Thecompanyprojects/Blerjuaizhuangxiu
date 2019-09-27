//
//  GoodsParameterView.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDiscountCell.h"
@class GoodsParamterModel;
@class PromptModel;
@class ActivityListModel;

typedef void(^completionBlock)(BOOL isSuccess);

@protocol GoodsParameterViewDelegate <NSObject>
- (void)didSelectedPromotionAt:(NSInteger)index withPromptModel:(ActivityListModel *)promptModel goodsDiscountCell:(GoodsDiscountCell *)cell;
@end

@interface GoodsParameterView : UIView
@property (nonatomic, strong) NSString *topTitle;

// 商品参数数组  服务承诺 全部使用这个， 使用同一个model
@property (nonatomic, strong) NSMutableArray<GoodsParamterModel *> *listArray;

//优惠券 数组
@property (nonatomic, strong) NSMutableArray<ActivityListModel *> *promptArray;

@property (nonatomic, weak) id<GoodsParameterViewDelegate> delegate;

@property (nonatomic, copy) void(^finishBlock)(GoodsParameterView *paramView);


@end
