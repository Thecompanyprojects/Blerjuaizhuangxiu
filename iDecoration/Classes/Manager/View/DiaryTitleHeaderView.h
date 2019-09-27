//
//  DiaryTitleHeaderView.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiaryTitleHeaderViewDelegate <NSObject>
-(void)addPointWith:(NSInteger)tag;
@end

@interface DiaryTitleHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *rowImgV;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, weak) id<DiaryTitleHeaderViewDelegate>delegate;
@property (nonatomic, copy) void(^tapBlock)();

@end
