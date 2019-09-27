//
//  SRAudioPlayer.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/15.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRAudioPlayer : NSObject
{
    AVAudioPlayer *_audioPlayer1;
    AVAudioPlayer *_audioPlayer2;
}
@property (nonatomic,assign) float pan;    // 调节声道平衡
@property (nonatomic,assign) float volume; // 调节音量
// 初始化
- (id)initWithContentsOfURL:(NSURL *)URL error:(NSError *__autoreleasing *)outError;

// 播放一次
- (void)playOnce;

// 循环播放
- (void)playInfinite;

// 播放并震动
- (void)playOnceWithVibrate;

- (void)pause;

- (void)stop;
- (void)playWithCount:(NSInteger)count;
- (void)playThird;
// 振动
- (void)vibrate; 
@end

NS_ASSUME_NONNULL_END
