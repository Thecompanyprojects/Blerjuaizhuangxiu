//
//  LocalMusicCell.m
//  iDecoration
//
//  Created by sty on 2017/9/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "LocalMusicCell.h"
#import "LocalMusicModel.h"

@implementation LocalMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)configData:(id)data isShowCheck:(BOOL)isShowCheck{
    if ([data isKindOfClass:[LocalMusicModel class]]) {
        LocalMusicModel *model = data;
        self.songL.text = model.picTitle;
        self.selectImg.hidden = !isShowCheck;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
