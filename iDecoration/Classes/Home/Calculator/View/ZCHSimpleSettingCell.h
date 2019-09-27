//
//  ZCHSimpleSettingCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCHSimpleSettingCellDelegate <NSObject>

@optional
- (void)didClickDeleteBtnWithIndexpath:(NSIndexPath *)indexpath andIndex:(NSInteger)index;

@end

@interface ZCHSimpleSettingCell : UITableViewCell

@property (weak, nonatomic) id<ZCHSimpleSettingCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexpath;
@property (assign, nonatomic) BOOL isShowMinusBtn;

- (void)settingCellWithData:(NSArray *)arr;


@end
