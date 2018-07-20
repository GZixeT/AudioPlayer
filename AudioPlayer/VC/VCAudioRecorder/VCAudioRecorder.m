//
//  VCAudioRecorder.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "VCAudioRecorder.h"
#import "AudioManager.h"
#import "ErrorManager.h"
#import "AudioPlayer.h"

@interface VCAudioRecorder ()
@property AVAudioRecorder *recorder;
@property AudioPlayer *manager;
@property NSTimer *timerRecord;
@property int count;
@end

@implementation VCAudioRecorder

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerRecord = nil;
    self.manager = [AudioPlayer sharedInstance];
    self.navigationItem.title = @"Audio Recorder";
    self.lbRecTime.text = @"0";
    self.lbPlayProgress.text = @"0/0";
    self.count = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bRecAction:(id)sender {
    if(!self.recorder.isRecording) {
        self.count++;
        [AudioManager setSessionCategoryForRecordAndPlayWithError:nil];
        NSString *path = [NSString stringWithFormat:@"%@/record_%d.caf",[[NSBundle mainBundle]resourcePath],self.count];
        self.recorder = [AudioManager createAudioRecorderWithFilePath:path error:nil];
        [self.recorder record];
        self.timerRecord = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordProgress) userInfo:nil repeats:YES];
    }
}
- (void) recordProgress {
    if(self.recorder.isRecording) {
        self.lbRecTime.text = [NSString stringWithFormat:@"%d",(int)[self.recorder currentTime]];
    } else {
        [self.timerRecord invalidate];
        self.timerRecord = nil;
    }
}
- (IBAction)bStopRecAction:(id)sender {
    if(self.recorder.isRecording) {
        self.lbPlayProgress.text = [NSString stringWithFormat:@"0/%d",(int)[self.recorder currentTime]];
        [self.recorder stop];
        [self.timerRecord invalidate];
        self.timerRecord = nil;
    }
}
- (IBAction)bPlayAction:(id)sender {
    if(!self.recorder.isRecording) {
        NSError *error = nil;
        self.manager.audioPlayer = [AudioManager createAudioPlayerWithFilePath:self.recorder.url.absoluteString error:&error];
        if(!error) {
            [self.manager.audioPlayer play];
            self.timerRecord = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playingProgress) userInfo:nil repeats:YES];
        } else [ErrorManager errorWithTitle:@"Ошибка" message:@"Записи еще нет"];
    }
}
- (IBAction)bStopPlayAction:(id)sender {
    if(self.manager.audioPlayer.isPlaying) {
        [self.manager.audioPlayer stop];
        [self.timerRecord invalidate];
        self.timerRecord = nil;
    }
}
- (void) playingProgress {
    float multiplier = [self.manager.audioPlayer currentTime]/[self.manager.audioPlayer duration];
    self.lbPlayProgress.text = [NSString stringWithFormat:@"%d/%d",(int)[self.manager.audioPlayer currentTime],(int)[self.manager.audioPlayer duration]];
    self.pbRecord.progress = multiplier;
    if(!self.manager.audioPlayer.isPlaying) {
        [self.timerRecord invalidate];
        self.timerRecord = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
