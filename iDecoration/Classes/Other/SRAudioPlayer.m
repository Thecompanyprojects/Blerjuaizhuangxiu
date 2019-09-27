//
//  SRAudioPlayer.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/15.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "SRAudioPlayer.h"

@implementation SRAudioPlayer
{
    BOOL _isPlayingAudioPlayer1;
}

- (id)initWithContentsOfURL:(NSURL *)URL error:(NSError *__autoreleasing *)outError
{
    if ((self = [super init])) {
        _audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:outError];
        _audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:outError];

        [_audioPlayer1 prepareToPlay];
        [_audioPlayer2 prepareToPlay];
    }
    return self;
}

- (void)setPan:(float)pan
{
    if (_pan != pan) {
        _pan = pan;
        _audioPlayer1.pan = pan;
        _audioPlayer2.pan = pan;
    }

}

- (void)setVolume:(float)volume
{
    if (_volume != volume) {
        _volume = volume;
        _audioPlayer1.volume = volume;
        _audioPlayer2.volume = volume;
    }
}

- (void)playOnce
{
    _audioPlayer1.numberOfLoops = 1;
    if (!_isPlayingAudioPlayer1) {
        if (!_audioPlayer1.isPlaying) [_audioPlayer1 play];
        else _audioPlayer1.currentTime = 0.0f;
        _isPlayingAudioPlayer1 = YES;
    } else {
        if (!_audioPlayer2.isPlaying)[_audioPlayer2 play];
        else _audioPlayer2.currentTime = 0.0f;
        _isPlayingAudioPlayer1 = NO;
    }
}

- (void)playThird {

}

- (void)playWithCount:(NSInteger)count {
    NSInteger c = count;
    [_audioPlayer2 pause];
    _audioPlayer1.currentTime = 0.0f;
    _audioPlayer1.numberOfLoops = c;
    [_audioPlayer1 play];
}

- (void)playInfinite
{
    [_audioPlayer2 pause];
    _audioPlayer1.currentTime = 0.0f;
    _audioPlayer1.numberOfLoops = -1;
}

- (void)playOnceWithVibrate  //1
{
    _audioPlayer1.numberOfLoops = 1;
    if (!_isPlayingAudioPlayer1) {
        if (!_audioPlayer1.isPlaying) [_audioPlayer1 play];
        else _audioPlayer1.currentTime = 0.0f;
        _isPlayingAudioPlayer1 = YES;
    } else {
        if (!_audioPlayer2.isPlaying)[_audioPlayer2 play];
        else _audioPlayer2.currentTime = 0.0f;
        _isPlayingAudioPlayer1 = NO;
    }
    [self vibrate];
}

- (void)pause
{
    [_audioPlayer1 pause];
    [_audioPlayer2 pause];
}

- (void)stop
{
    [_audioPlayer1 stop];
    [_audioPlayer2 stop];
}

- (void)vibrate
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}  
@end
