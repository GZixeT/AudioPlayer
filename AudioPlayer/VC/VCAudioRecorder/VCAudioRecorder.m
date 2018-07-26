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
#import "FileManager.h"
#import "AppManager.h"
#import "VCRecords.h"
#import "TimeManager.h"
#import "RLMRecords.h"
#import <Realm.h>

@interface VCAudioRecorder ()
@property (weak, nonatomic) IBOutlet UILabel *lbCounter;
@property AVAudioRecorder *recorder;
@property NSTimer *timerRecord;
@property NSInteger count;
@property NSString *recordPath;
@property TimeManager *timeManager;
@property RLMNotificationToken *nihao;
@end

@implementation VCAudioRecorder

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timerRecord = nil;
    self.timeManager = [TimeManager sharedInstance];
    self.navigationItem.title = @"Диктофон";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Записи" style:UIBarButtonItemStylePlain target:self action:@selector(goToRecords)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.bRec.layer.cornerRadius = self.bRec.frame.size.width/2;
    self.bRec.layer.borderColor = [UIColor blackColor].CGColor;
    self.bRec.layer.borderWidth = 2.f;
    [self setTime];
    [self setRecordPath];
    self.lbCounter.text = [NSString stringWithFormat:@"Количество записей: %d",(int)[RLMRecords allObjects].count];
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
        self.recordPath = [NSString stringWithFormat:@"%@/record_%d(%d).caf",[AppManager standartRecordFolder],(int)self.count,(int)[RLMRecords allObjects].count];
        NSError *error = nil;
        self.recorder = [AudioManager createAudioRecorderWithFilePath:self.recordPath error:&error];
        if(!error) {
            [self.recorder record];
            [self.bRec setTitle:@"Stop" forState:(UIControlStateNormal)];
            [AppManager addObjectForRealm:[RLMRecords createRLMRecords:[NSString stringWithFormat:@"%@/record_%d(%d).caf",[AppManager recordsBasicPath],(int)self.count,(int)[RLMRecords allObjects].count]]];
            self.timerRecord = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordProgress) userInfo:nil repeats:YES];
        } else [AlertManager alertWithTitle:@"Ошибка" message:@"Ошибка создания файла"];
    } else {
        [self.recorder stop];
        [self.timerRecord invalidate];
        self.timerRecord = nil;
        [self.bRec setTitle:@"Rec" forState:(UIControlStateNormal)];
        [AlertManager alertWithTitle:@"Успех" message:[NSString stringWithFormat:@"Запись сохранена:%@",[self.recordPath lastPathComponent]]];
        [self setRecordPath];
        [self setTime];
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
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.lbCounter.text = [NSString stringWithFormat:@"Количество записей: %d",(int)[RLMRecords allObjects].count];
    self.nihao = [[RLMRecords allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if(change) {
           self.lbCounter.text = [NSString stringWithFormat:@"Количество записей: %d",(int)[RLMRecords allObjects].count];
        }
    }];
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.nihao invalidate];
}
@end
