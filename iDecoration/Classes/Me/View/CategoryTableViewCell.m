//
//  CategoryTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(CategoryModel *)model{
    
    self.titleLabel.text = model.typeName;
}

-(void)configData:(id)data{
    if ([data isKindOfClass:[NSString class]]) {
        NSString *str = data;
        self.titleLabel.text = str;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
