//
//  GoodsDetailCommentCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsDetailCommentCell.h"

@implementation GoodsDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scoreLabel.textColor = kMainThemeColor;
    
    self.topImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageV.layer.cornerRadius = 25;
    self.topImageV.layer.masksToBounds = YES;
    
    self.bottomImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.bottomImageV.layer.masksToBounds = YES;
    
    self.commentPromptLabel.layer.cornerRadius = 4;
    self.commentPromptLabel.layer.masksToBounds = YES;
    self.commentPromptLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.commentPromptLabel.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(CommmentModel *)model {
    _model = model;
    [self.topImageV sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.nameLabel.text = [NSString stringWithFormat:@"业主 - %@", model.trueName];
    self.addressLabel.text = model.areaName;
    self.scoreLabel.text = model.sumGrade;
    
    self.commentLabel.text =[NSString stringWithFormat:@"              %@", model.content];
    self.commentPromptLabel.hidden = (model.content.length == 0);
    
    
    if (model.frontPage.length>0) {
        [self.bottomImageV sd_setImageWithURL:[NSURL URLWithString:model.frontPage]];
    } else {
        self.bottomImageV.image = [UIImage imageNamed:@"defaultCompanyLogo"];
    }
    self.titleLabel.text = model.shareTitle.length > 0 ? model.shareTitle : @"";
    
}

@end
