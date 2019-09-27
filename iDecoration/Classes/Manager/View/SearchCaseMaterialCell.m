//
//  SearchCaseMaterialCell.m
//  iDecoration
//
//  Created by Apple on 2017/7/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SearchCaseMaterialCell.h"
#import "CaseMaterialModel.h"

@implementation SearchCaseMaterialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configData:(id)data{
    if ([data isKindOfClass:[CaseMaterialModel class]]) {
        CaseMaterialModel *model = data;
        self.HouseManL.text = model.CC_HOUSEHOLDER_NAME;
        self.ConsManL.text = model.ccBuilder;
        [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:model.coverMap] placeholderImage:[UIImage imageNamed:DefaultIcon]];
    }
}

@end
