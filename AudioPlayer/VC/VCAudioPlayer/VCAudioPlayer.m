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
#import "TimeManager.h"

@interface VCAudioPlayer ()
@property TimeManager *timeManager;
@property AudioPlayer *audioPlayer;
@property NSTimer *trackTimer;
@end

@implementation VCAudioPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeManager = [TimeManager sharedInstance];
    self.audioPlayer = [AudioPlayer sharedInstance];
    self.trackTimer = nil;
    self.navigationItem.title = @"Плеер";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    if(self.audioPlayer.audioPlayer.isPlaying) {
        [self.bPlay setTitle:@"Stop" forState:(UIControlStateNormal)];
        if(!self.trackTimer)
            self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackProgress) userInfo:nil repeats:YES];
    }
    else [self.bPlay setTitle:@"Play" forState:(UIControlStateNormal)];
    self.lbArtistAndSong.text = [NSString stringWithFormat:@"%@ - %@",self.audioPlayer.artist, self.audioPlayer.title];
    [AudioManager setSessionCategoryForMultiRouteWithError:nil];
    self.bPlay.layer.cornerRadius = self.bPlay.frame.size.width/2;
    self.bPlay.layer.borderWidth = 2.f;
    self.bPlay.layer.borderColor = [UIColor blackColor].CGColor;
    self.artworkImageView.layer.cornerRadius = self.artworkImageView.frame.size.width/2;
    self.artworkImageView.clipsToBounds = YES;
    self.artworkImageView.layer.borderWidth = 3.f;
    self.artworkImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.artworkImageView setImage:self.audioPlayer.artwork];
    [self setTime];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bPlayAction:(id)sender {
    [self setTime];
    if(self.audioPlayer.audioPlayer.isPlaying) {
        [self.bPlay setTitle:@"Play" forState:(UIControlStateNormal)];
        [self.audioPlayer.audioPlayer stop];
        [self.trackTimer invalidate];
        self.trackTimer = nil;
    } else {
        [self.bPlay setTitle:@"Stop" forState:(UIControlStateNormal)];
        [self.audioPlayer.audioPlayer play];
        if(!self.trackTimer)
            self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackProgress) userInfo:nil repeats:YES];
    }
}
- (void) trackProgress {
    float multiplier = [self.audioPlayer.audioPlayer currentTime]/[self.audioPlayer.audioPlayer duration];
    [self setTime];
    self.pbAudioTrack.progress = multiplier;
    if(!self.audioPlayer.audioPlayer.isPlaying){
        [self.trackTimer invalidate];
        self.trackTimer = nil;
    }
}
- (void) setTime {
    self.lbTimeLeft.text = [self.timeManager dateFormatSecondsToMinutes:[self.audioPlayer.audioPlayer currentTime]];
    self.lbTimeRight.text = [self.timeManager dateFormatSecondsToMinutes:[self.audioPlayer.audioPlayer duration]];
}
@end
