//
//  AudioPlayer.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 20/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
typedef enum {
    PlayTypeAll,
    PlayTypeSingle,
    PlayTypePlayList
}PlayType;

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface AudioPlayer : NSObject
@property AVAudioPlayer *audioPlayer;
@property UIImage *artwork;
@property NSString *title;
@property NSString *artist;
@property NSInteger playlistPosition;
@property PlayType playType;
+ (instancetype) sharedInstance;
- (void) setAudioPlayer:(AVAudioPlayer *)audioPlayer;
- (AVAudioPlayer*) audioPlayer;
@end
