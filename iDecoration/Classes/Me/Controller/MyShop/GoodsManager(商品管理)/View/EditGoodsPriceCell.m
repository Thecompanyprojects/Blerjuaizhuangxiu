//
//  EditGoodsPriceCell.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EditGoodsPriceCell.h"

@interface EditGoodsPriceCell()




@end

@implementation EditGoodsPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.contentMode = MPMovieScalingModeAspectFill;
    self.imageV.layer.cornerRadius = 4;
    self.imageV.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImageAction)];
    self.imageV.userInteractionEnabled = YES;
    [self.imageV addGestureRecognizer:tapGR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsPriceModel *)model {
    _model = model;
    self.nameTF.text = model.name;
    self.priceTF.text = model.price;
    self.unitTF.text = model.unit;
    self.numTF.text = model.num;
    if (model.image) {
        self.imageV.image = model.image;
    }else if(model.imageURL) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"shangchuan"]];
    }
}

- (IBAction)deleteActin:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editGoodsPriceCellDeleteAction:)]) {
        [self.delegate editGoodsPriceCellDeleteAction:self];
    }
}

- (void)uploadImageAction {
    if ([self.delegate respondsToSelector:@selector(editGoodsPriceCellUploadImage:)]) {
        [self.delegate editGoodsPriceCellUploadImage:self];
    }
}



@end
