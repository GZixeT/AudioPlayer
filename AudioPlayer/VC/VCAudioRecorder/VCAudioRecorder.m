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
#import "AlertManager.h"
#import "AudioPlayer.h"
#import "FileManager.h"
#import "AppManager.h"

@interface VCAudioRecorder ()
@property AVAudioRecorder *recorder;
@property AudioPlayer *manager;
@property NSTimer *timerRecord;
@property NSInteger count;
@property NSString *recordPath;
@end

@implementation VCAudioRecorder

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerRecord = nil;
    self.manager = [AudioPlayer sharedInstance];
    self.navigationItem.title = @"Audio Recorder";
    self.lbRecTime.text = @"0";
    self.count = [FileManager getFileNamesWithPath:[AppManager standartRecordFolder]].count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)bRecAction:(id)sender {
    if(!self.recorder.isRecording) {
        self.count++;
        [AudioManager setSessionCategoryForRecordAndPlayWithError:nil];
        self.recordPath = [NSString stringWithFormat:@"%@/record_%d.caf",[AppManager standartRecordFolder],(int)self.count];
        self.recorder = [AudioManager createAudioRecorderWithFilePath:self.recordPath error:nil];
        [self.recorder record];
        [self.bRec setTitle:@"Stop" forState:(UIControlStateNormal)];
        self.timerRecord = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordProgress) userInfo:nil repeats:YES];
    } else {
        [self.recorder stop];
        [self.timerRecord invalidate];
        self.timerRecord = nil;
        [self.bRec setTitle:@"Rec" forState:(UIControlStateNormal)];
        [AlertManager alertWithTitle:@"Успех" message:[NSString stringWithFormat:@"Запись сохранена:records/%@",[self.recordPath lastPathComponent]]];
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
@end
