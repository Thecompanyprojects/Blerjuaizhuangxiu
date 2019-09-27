//
//  GoodsEditSectionView.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsEditSectionView;

@protocol GoodsEditSectionViewDelegate <NSObject>

- (void)editSectionView:(GoodsEditSectionView *)view addActionWithIndexPath:(NSInteger)section;
- (void)editSectionView:(GoodsEditSectionView *)view addTextActionWithIndexPath:(NSInteger)section;
- (void)editSectionView:(GoodsEditSectionView *)view addImageActionWithIndexPath:(NSInteger)section;
- (void)editSectionView:(GoodsEditSectionView *)view addVideoActionWithIndexPath:(NSInteger)section;

@end

@interface GoodsEditSectionView : UITableViewHeaderFooterView

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIButton *addTextBtn;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UIButton *addVideoBtn;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) id<GoodsEditSectionViewDelegate> delegate;

@end
