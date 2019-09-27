//
//  BackGoodsListBottomView.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackGoodsListBottomView;

@protocol BackGoodsListBottomViewDelegate <NSObject>

/**
 按钮方法

 @param View 底部视图
 @param index 按钮的顺序 从0开始  一次是 @[@"添加商品", @"商品推广", @"批量管理", @"分组管理"]
 */
- (void)bottomView:(BackGoodsListBottomView *)View BtnClicked:(NSInteger)index;

@end

@interface BackGoodsListBottomView : UIView

@property (nonatomic, weak) id<BackGoodsListBottomViewDelegate> delegate;

//- (instancetype)initwithTitleArray:(NSArray *)titleArray;
@property (nonatomic, strong) NSArray* titleArray;
@end
