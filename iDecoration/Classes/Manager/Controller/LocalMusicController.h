//
//  LocalMusicController.h
//  iDecoration
//
//  Created by sty on 2017/9/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface LocalMusicController : SNViewController
@property (nonatomic, copy) void(^localMusicBlock)(NSString *musicUrl,NSString *songName);
@property (nonatomic, copy) NSString *musicUrl;//音乐的url
@property (nonatomic, copy) NSString *songName;//音乐名称
@end
