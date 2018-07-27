//
//  AudioPlayer.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 20/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "AudioPlayer.h"
@interface AudioPlayer()
@end

static AudioPlayer *sharedInstance = nil;
@implementation AudioPlayer
@synthesize audioPlayer = _audioPlayer;
+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[AudioPlayer alloc]init];
    });
    return sharedInstance;
}
- (void) setAudioPlayer:(AVAudioPlayer *)audioPlayer {
    if(_audioPlayer.isPlaying) {
        [_audioPlayer stop];
    }
    _audioPlayer = audioPlayer;
}
- (AVAudioPlayer*) audioPlayer {
    return _audioPlayer;
}
- (instancetype) init {
    if(self = [super init]) {
        self.audioPlayer = nil;
        self.artwork = nil;
    }
    return self;
}
@end
