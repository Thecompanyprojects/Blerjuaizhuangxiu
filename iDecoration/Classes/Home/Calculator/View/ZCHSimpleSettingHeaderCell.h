//
//  ZCHSimpleSettingHeaderCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCHSimpleSettingHeaderCellDelegate <NSObject>

@optional

- (void)didClickSwitch:(UISwitch *)switchBtn;

@end


@interface ZCHSimpleSettingHeaderCell : UITableViewHeaderFooterView

//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UISwitch *switchBtn;

@property (weak, nonatomic) id<ZCHSimpleSettingHeaderCellDelegate> delegate;

@end
