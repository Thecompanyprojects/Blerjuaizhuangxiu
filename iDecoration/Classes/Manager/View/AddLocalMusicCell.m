//
//  AddLocalMusicCell.m
//  iDecoration
//
//  Created by sty on 2017/9/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddLocalMusicCell.h"

@implementation AddLocalMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configWith:(NSString *)songName singer:(NSString *)singer isShowSelect:(BOOL)isShowSelect
{
    self.songName.text = songName;
    self.singerName.text = singer;
    
    self.selectImg.hidden = !isShowSelect;
}
@end
