//
//  CustomParameterItemView.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsParamterModel.h"
#import "GoodsPriceModel.h"
@class CustomParameterItemView;

@protocol CustomParameterItemViewDelegate <NSObject>
- (void)parameterItemViewAddItemAction:(CustomParameterItemView *)parameterItemView;
- (void)parameterItemViewDeleteItemAction:(CustomParameterItemView *)parameterItemView atIndex:(NSInteger)index;
@end

@interface CustomParameterItemView : UIView

@property (nonatomic, copy) void(^finishBlock)(CustomParameterItemView *promptView);
@property (nonatomic, weak) id<CustomParameterItemViewDelegate> delegate;

// 参数 服务
@property (nonatomic, strong) NSMutableArray<GoodsParamterModel *> *listArray;

// 价格
@property (nonatomic, strong) NSMutableArray<GoodsPriceModel *> *priceArray;
@property (nonatomic, assign) BOOL isfromPrice;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addBtn;
@end
