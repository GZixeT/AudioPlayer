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

@interface VCAudioPlayer () <AVAudioPlayerDelegate>
@property AVAudioPlayer *audioPlayer;
@property NSTimer *trackTimer;
@end

@implementation VCAudioPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [NSString stringWithFormat:@"%@/firstAudio.mp3",[[NSBundle mainBundle]resourcePath]];
    self.trackTimer = nil;
    self.navigationItem.title = @"Audio Player";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(goToRecord)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.audioPlayer = [AudioManager createAudioPlayerWithFilePath:path error:nil];
    self.lbTime.text = [NSString stringWithFormat:@"%d/%d",(int)[self.audioPlayer currentTime],(int)[self.audioPlayer duration]];
    self.audioPlayer.delegate = self;
    [AudioManager setSessionCategoryForMultiRouteWithError:nil];
    // Do any additional setup after loading the view.
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
    if(!self.audioPlayer.isPlaying) {
        [self.audioPlayer play];
        if(!self.trackTimer)
            self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackProgress) userInfo:nil repeats:YES];
    }
}
- (IBAction)bStopAction:(id)sender {
    if(self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
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
    float multiplier = [self.audioPlayer currentTime]/[self.audioPlayer duration];
    self.pbAudioTrack.progress = multiplier;
    self.lbTime.text = [NSString stringWithFormat:@"%d/%d",(int)[self.audioPlayer currentTime],(int)[self.audioPlayer duration]];
    if(!self.audioPlayer.isPlaying){
        [self.trackTimer invalidate];
        self.trackTimer = nil;
    }
}
@end
