//
//  AudioManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
// Настройки аудио
//https://developer.apple.com/documentation/avfoundation/avaudiorecorder/encoder_settings?language=objc
//https://developer.apple.com/documentation/avfoundation/avaudioplayer/general_audio_format_settings?language=objc
//https://developer.apple.com/documentation/avfoundation/audio_track_engineering/audio_settings_and_formats/sample_rate_conversion_settings?language=objc

#import "AudioManager.h"
@interface AudioManager()
@end

@implementation AudioManager
+ (AVAudioPlayer*) createAudioPlayerWithFilePath:(NSString*)path error:(NSError**)ourError {
    NSURL *soundURL = [NSURL URLWithString:path];
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if(error) {
        NSLog(@"incorrect create AudioPlayer");
        NSLog(@"Error: %@",error);
        *ourError = error;
    } else NSLog(@"Correct creation AudioPlayer");
    return audioPlayer;
}
+ (AVAudioRecorder*) createAudioRecorderWithFilePath:(NSString*)path settings:(NSDictionary*)settings error:(NSError**)outError {
    NSURL *soundURL = [NSURL URLWithString:path];
    NSError *error = nil;
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:soundURL settings:settings error:&error];
    if(error) {
        NSLog(@"incorrect create AudioRecorder");
        NSLog(@"Error: %@",error);
        *outError = error;
    } else NSLog(@"Correct creation AudioRecorder");
    return recorder;
}
+ (AVAudioRecorder*) createAudioRecorderWithFilePath:(NSString*)path error:(NSError**)outError {
    NSURL *soundURL = [NSURL URLWithString:path];
    NSError *error = nil;
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey, nil];
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:soundURL settings:recordSettings error:&error];
    if(error) {
        NSLog(@"incorrect create AudioRecorder");
        NSLog(@"Error: %@",error);
        *outError = error;
    } else NSLog(@"Correct creation AudioRecorder");
    return recorder;
}
+ (void) setSessionCategoryForRecordAndPlayWithError:(NSError**)outError {
    NSError *sessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(sessionError) {
        NSLog(@"incorrect setCategory 'record and play' AudioSession");
        NSLog(@"Error: %@",sessionError);
        *outError = sessionError;
    } else NSLog(@"Correct setCategory 'record and play' AudioSession");
}
+ (void) setSessionCategoryForMultiRouteWithError:(NSError**)outError {
    NSError *sessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    if(sessionError) {
        NSLog(@"incorrect setCategory 'multiroute' AudioSession");
        NSLog(@"Error: %@",sessionError);
        *outError = sessionError;
    } else NSLog(@"Correct setCategory 'multiroute' AudioSession");
}
@end
