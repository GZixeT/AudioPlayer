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
@property (nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation AudioManager
+ (void) standartError:(NSError**)outError error:(NSError*)error avtype:(NSString*)type {
    if(error) {
        NSLog(@"incorrect %@",type);
        NSLog(@"Error: %@",error);
        if(outError)
            *outError = error;
    } else NSLog(@"Correct %@",type);
}
+ (AVAudioPlayer*) createAudioPlayerWithFilePath:(NSString*)path error:(NSError**)outError {
    NSString *npath = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *soundURL = [NSURL URLWithString:npath];
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [self standartError:&*outError error:error avtype:@"create AudioPlayer"];
    return audioPlayer;
}
+ (AVAudioRecorder*) createAudioRecorderWithFilePath:(NSString*)path settings:(NSDictionary*)settings error:(NSError**)outError {
    NSString *npath = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *soundURL = [NSURL URLWithString:npath];
    NSError *error = nil;
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:soundURL settings:settings error:&error];
    [self standartError:&*outError error:error avtype:@"create AudioRecorder"];
    return recorder;
}
+ (AVAudioRecorder*) createAudioRecorderWithFilePath:(NSString*)path error:(NSError**)outError {
    NSString *npath = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *soundURL = [NSURL URLWithString:npath];
    NSError *error = nil;
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey, nil];
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:soundURL settings:recordSettings error:&error];
    [self standartError:&*outError error:error avtype:@"create AudioRecorder"];
    return recorder;
}
+ (void) setSessionCategoryForRecordAndPlayWithError:(NSError**)outError {
    NSError *sessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [self standartError:&*outError error:sessionError avtype:@"setCategory AudioSession"];
}
+ (void) setSessionCategoryForMultiRouteWithError:(NSError**)outError {
    NSError *sessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [self standartError:&*outError error:sessionError avtype:@"setCategory AudioSession"];
}
@end
