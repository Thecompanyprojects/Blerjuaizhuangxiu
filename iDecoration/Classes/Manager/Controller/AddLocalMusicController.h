//
//  AddLocalMusicController.h
//  iDecoration
//
//  Created by sty on 2017/9/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "LocalMusicModel.h"

@interface AddLocalMusicController : SNViewController
@property (nonatomic, copy) void(^addLocalMusicBlock) (LocalMusicModel *model);
@end
