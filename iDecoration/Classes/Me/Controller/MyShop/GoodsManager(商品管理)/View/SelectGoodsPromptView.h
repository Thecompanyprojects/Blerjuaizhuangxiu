//
//  SelectGoodsPromptView.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectGoodsPromptView;

@protocol SelectGoodsPromptViewDelegate <NSObject>
- (void)didSelectedTitleAt:(NSInteger)index;

- (void)selectGoodsPromptView:(SelectGoodsPromptView *)view addBtnActionAtIndex:(NSInteger)index;
- (void)selectGoodsPromptView:(SelectGoodsPromptView *)view subBtnActionAtIndex:(NSInteger)index;

@end

@interface SelectGoodsPromptView : UIView

@property (nonatomic, copy) void(^finishBlock)(SelectGoodsPromptView *promptView);

//@property (nonatomic, strong) NSMutableArray<GoodsPriceModel *> *priceArray;
@property (nonatomic, strong) NSArray *buttonTitleArray;
@property (nonatomic, weak) id<SelectGoodsPromptViewDelegate> delegate;



@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *numBottomLabel;

@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *buyView;
@property (nonatomic, strong) UILabel *buyNumNameLabel;
@property (nonatomic, strong) UILabel *buyNumLabel;
@property (nonatomic, strong) UIButton *subButton;
@property (nonatomic, strong) UIButton *addButton;


@end
