//
//  ZCHSettingChangeNetCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCHSettingChangeNetCellDelegate <NSObject>

@optional
- (void)didClickSelectedBtn:(UIButton *)btn withIndexpath:(NSIndexPath *)indexpath;

@end

@interface ZCHSettingChangeNetCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ZCHSettingChangeNetCellDelegate> delegate;

@end
