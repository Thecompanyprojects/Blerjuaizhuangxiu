//
//  ZCHSimpleBottomCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHSimpleSettingMessageModel;

@interface ZCHSimpleBottomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UITextField *unitPrice;
@property (strong, nonatomic) ZCHSimpleSettingMessageModel *model;

@end
