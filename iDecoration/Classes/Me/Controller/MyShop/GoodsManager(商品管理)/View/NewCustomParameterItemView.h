//
//  NewCustomParameterItemView.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsParamterModel.h"
@class NewCustomParameterItemView;

@protocol NewCustomParameterItemViewDelegate <NSObject>

- (void)newParameterItemViewAddItemAction:(NewCustomParameterItemView *)parameterItemView;
- (void)newParameterItemViewDeleteItemAction:(NewCustomParameterItemView *)parameterItemView withTitleName:(NSString *)title;
- (void)newParameterItemViewAddItemAction:(NewCustomParameterItemView *)parameterItemView withTitleName:(NSString *)title;

@end


@interface NewCustomParameterItemView : UIView
@property (nonatomic, copy) void(^finishBlock)(NewCustomParameterItemView *promptView);
@property (nonatomic, weak) id<NewCustomParameterItemViewDelegate> delegate;

// 参数
@property (nonatomic, strong) NSMutableArray<GoodsParamterModel *> *listArray;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, assign) BOOL isImplementOrGeneralManager; // 是总经理或执行经理
@property (nonatomic, strong) NSMutableArray *regularArray; // 总经理或执行经理定义的商品参数
@end
