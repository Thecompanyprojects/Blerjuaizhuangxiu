//
//  EditGoodsParameterCell.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EditGoodsParameterCell.h"

@implementation EditGoodsParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.describeTVHeight.constant = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setName:(NSString *)name andDescribe:(NSString *)describe {
    self.nameTF.text = name;
    self.nameNumLabel.text = [NSString stringWithFormat:@"%ld/8", name.length];
    self.describeTV.text = describe;
    self.describeNumLabel.text = [NSString stringWithFormat:@"%ld/20", describe.length];
    
    CGSize size = [self.describeTV sizeThatFits:CGSizeMake(CGRectGetWidth(self.describeTV.frame), CGFLOAT_MAX)];
    CGFloat height = size.height;
    if (height <= 20) {
        self.describeTVHeight.constant = 20;
    }else{
        self.describeTVHeight.constant = height;
    }
}

- (void)setNewParamName:(NSString *)name andDescribe:(NSString *)describe {
    self.nameLabel.text= name;
    self.describeTV.text = describe;
    self.describeTVPlaceHolder.hidden = describe.length > 0;
    CGSize size = [self.describeTV sizeThatFits:CGSizeMake(CGRectGetWidth(self.describeTV.frame), CGFLOAT_MAX)];
    CGFloat height = size.height;
    if (height <= 20) {
        self.describeTVHeight.constant = 20;
    }else{
        self.describeTVHeight.constant = height;
    }
}

- (IBAction)deleAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editGoodsParameterCellDeleteAction:)]) {
        [self.delegate editGoodsParameterCellDeleteAction:self];
    }
}

@end
