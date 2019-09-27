//
//  BannerListCell.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BannerListCell.h"

@implementation BannerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconIV.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIV.layer.cornerRadius = 20;
    self.iconIV.layer.masksToBounds = YES;
    
    self.iconIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction)];
    [self.iconIV addGestureRecognizer: tapGR];
}

- (void)imageViewTapAction {
    if (self.IconIVTapBlock) {
        self.IconIVTapBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBannerListModel:(BannerListModel *)bannerListModel {
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:bannerListModel.photo]];
    self.nameLabel.text = bannerListModel.trueName;
    self.timeLabel.text = bannerListModel.modified;
    self.timeLabel.text = [NSDate yearMoneyDayAndHourMinuteFromTimeInterval:bannerListModel.modified.doubleValue/1000.0];
    self.leaveWordsLabel.text = bannerListModel.leaveWord;

    if (self.bannerListModel.type.integerValue <2000) {
        self.rightImageView.hidden = NO;
    } else {
        self.rightImageView.hidden = YES;
    }
    if (bannerListModel.leaveWord.length > 0) {
        self.leaveWordsTopToImageViewCon.constant = 15;
    } else {
        self.leaveWordsTopToImageViewCon.constant = 0;
    }
}
@end
