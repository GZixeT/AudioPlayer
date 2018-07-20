//
//  VCAudioPlayer.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "VCAudioPlayer.h"
#import "AudioManager.h"
#import "VCAudioRecorder.h"
#import "AudioPlayer.h"

@interface VCAudioPlayer () <AVAudioPlayerDelegate>
@property AudioPlayer *audioPlayer;
@property NSTimer *trackTimer;
@end

@implementation VCAudioPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.audioPlayer = [AudioPlayer sharedInstance];
    self.trackTimer = nil;
    self.navigationItem.title = @"Audio Player";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(goToRecord)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.lbTime.text = [NSString stringWithFormat:@"0/0"];
    [AudioManager setSessionCategoryForMultiRouteWithError:nil];
}
- (IBAction)bFileManagerAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioRecorder *fileManagerView = [storyboard instantiateViewControllerWithIdentifier:@"FileManager"];
    [self.navigationController pushViewController:fileManagerView animated:YES];
}
- (void) goToRecord {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioRecorder *recordView = [storyboard instantiateViewControllerWithIdentifier:@"AudioRecorder"];
    [self.navigationController pushViewController:recordView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bPlayAction:(id)sender {
    NSString *path = [NSString stringWithFormat:@"%@/firstAudio.mp3",[[NSBundle mainBundle]resourcePath]];
    self.audioPlayer.audioPlayer = [AudioManager createAudioPlayerWithFilePath:path error:nil];
    self.lbTime.text = [NSString stringWithFormat:@"%d/%d",(int)[self.audioPlayer.audioPlayer currentTime],(int)[self.audioPlayer.audioPlayer duration]];
    self.audioPlayer.audioPlayer.delegate = self;
    [self.audioPlayer.audioPlayer play];
    if(!self.trackTimer)
        self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackProgress) userInfo:nil repeats:YES];
}
- (IBAction)bStopAction:(id)sender {
    if(self.audioPlayer.audioPlayer.isPlaying) {
        [self.audioPlayer.audioPlayer stop];
        [self.trackTimer invalidate];
        self.trackTimer = nil;
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"finish");
    if(!player.isPlaying) {
        NSLog(@"finish");
    }
}
- (void) trackProgress {
    float multiplier = [self.audioPlayer.audioPlayer currentTime]/[self.audioPlayer.audioPlayer duration];
    self.pbAudioTrack.progress = multiplier;
    self.lbTime.text = [NSString stringWithFormat:@"%d/%d",(int)[self.audioPlayer.audioPlayer currentTime],(int)[self.audioPlayer.audioPlayer duration]];
    if(!self.audioPlayer.audioPlayer.isPlaying){
        [self.trackTimer invalidate];
        self.trackTimer = nil;
    }
}
@end
