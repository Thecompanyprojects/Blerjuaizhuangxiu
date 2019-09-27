//
//  ZCHSimpleSettingHeaderDetailCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHSimpleSettingMessageModel;

@protocol ZCHSimpleSettingHeaderDetailCellDelegate <NSObject>

@optional
- (void)didClickSwitchBtn:(UISwitch *)btn andType:(NSString *)type;

@end


@interface ZCHSimpleSettingHeaderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *TaxSwith;
@property (weak, nonatomic) IBOutlet UISwitch *designSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *detailPriceSwitch;
@property (strong, nonatomic) ZCHSimpleSettingMessageModel *model;
@property (assign, nonatomic) id<ZCHSimpleSettingHeaderDetailCellDelegate> delegate;

@end
