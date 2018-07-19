//
//  AudioManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface AudioManager : NSObject
+ (void) setSessionCategoryForRecordAndPlayWithError:(NSError**)outError;
+ (void) setSessionCategoryForMultiRouteWithError:(NSError**)outError;
+ (AVAudioPlayer*) createAudioPlayerWithFilePath:(NSString*)path error:(NSError**)ourError;
+ (AVAudioRecorder*) createAudioRecorderWithFilePath:(NSString*)path error:(NSError**)outError;
+ (AVAudioRecorder*) createAudioRecorderWithFilePath:(NSString*)path settings:(NSDictionary*)settings error:(NSError**)outError;
@end
