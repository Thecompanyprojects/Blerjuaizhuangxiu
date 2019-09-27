//
//  ZCHSimpleBottomCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSimpleBottomCell.h"
#import "ZCHSimpleSettingMessageModel.h"

@implementation ZCHSimpleBottomCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
