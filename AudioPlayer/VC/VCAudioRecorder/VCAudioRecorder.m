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
#import "VCRecords.h"
#import "TimeManager.h"

@interface VCAudioRecorder ()
@property AVAudioRecorder *recorder;
@property AudioPlayer *manager;
@property NSTimer *timerRecord;
@property NSInteger count;
@property NSString *recordPath;
@property TimeManager *timeManager;
@end

@implementation VCAudioRecorder

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerRecord = nil;
    self.timeManager = [TimeManager sharedInstance];
    self.manager = [AudioPlayer sharedInstance];
    self.navigationItem.title = @"Диктофон";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Записи" style:UIBarButtonItemStylePlain target:self action:@selector(goToRecords)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.bRec.layer.cornerRadius = self.bRec.frame.size.width/2;
    self.bRec.layer.borderColor = [UIColor blackColor].CGColor;
    self.bRec.layer.borderWidth = 2.f;
    [self setTime];
    [self setRecordPath];
}
- (void) setRecordPath {
    self.count = [FileManager getFileNamesWithPath:[AppManager standartRecordFolder]].count;
    self.count++;
    self.recordPath = [NSString stringWithFormat:@"%@/record_%d.caf",[AppManager standartRecordFolder],(int)self.count];
    self.lbRecordName.text = [self.recordPath lastPathComponent];
}
- (void) setTime {
    self.lbRecTime.text = [self.timeManager dateFormatSecondsToMinutes:[self.recorder currentTime]];
}
- (void) goToRecords {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCRecords *records = [storyboard instantiateViewControllerWithIdentifier:@"Records"];
    [self.navigationController pushViewController:records animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)bRecAction:(id)sender {
    [self setTime];
    if(!self.recorder.isRecording) {
        [AudioManager setSessionCategoryForRecordAndPlayWithError:nil];
        self.recordPath = [NSString stringWithFormat:@"%@/record_%d.caf",[AppManager standartRecordFolder],(int)self.count];
        NSError *error = nil;
        self.recorder = [AudioManager createAudioRecorderWithFilePath:self.recordPath error:&error];
        if(!error) {
            [self.recorder record];
            [self.bRec setTitle:@"Stop" forState:(UIControlStateNormal)];
            self.timerRecord = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordProgress) userInfo:nil repeats:YES];
        } else [AlertManager alertWithTitle:@"Ошибка" message:@"Ошибка создания файла"];
    } else {
        [self.recorder stop];
        [self.timerRecord invalidate];
        self.timerRecord = nil;
        [self.bRec setTitle:@"Rec" forState:(UIControlStateNormal)];
        [AlertManager alertWithTitle:@"Успех" message:[NSString stringWithFormat:@"Запись сохранена:%@",[self.recordPath lastPathComponent]]];
        [self recordPath];
    }
}
- (void) recordProgress {
    if(self.recorder.isRecording) {
        [self setTime];
    } else {
        [self.timerRecord invalidate];
        self.timerRecord = nil;
    }
}
@end
