//
//  AddLocalMusicCell.h
//  iDecoration
//
//  Created by sty on 2017/9/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLocalMusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImg;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;

@property (weak, nonatomic) IBOutlet UIImageView *selectImg;


-(void)configWith:(NSString *)songName singer:(NSString *)singer isShowSelect:(BOOL)isShowSelect;
@end
