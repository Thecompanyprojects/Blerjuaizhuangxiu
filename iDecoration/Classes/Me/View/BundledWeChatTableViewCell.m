//
//  BundledWeChatTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BundledWeChatTableViewCell.h"

@implementation BundledWeChatTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
