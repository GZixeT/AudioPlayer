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
#import "AnimationManager.h"
#import "LandscapeManager.h"

@interface VCAudioPlayer () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bPlace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bProgressWidthConstraint;
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
    self.bPlace.layer.cornerRadius = 15;
    self.bProgress.layer.cornerRadius = 15;
    if(self.audioPlayer.artwork){
        [self.artworkImageView setImage:self.audioPlayer.artwork];
    } else {
        self.artworkImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.artworkImageView setImage:[UIImage imageNamed:@"musical-note"]];
    }
    [self.bPlace addTarget:self action:@selector(setTimeAfterDrag:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bProgress  addTarget:self action:@selector(setTimeAfterDrag:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bPlace addTarget:self action:@selector(bDragMove:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.bProgress  addTarget:self action:@selector(bDragMove:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self setTime];
}
- (void) bDragMove:(id)sender withEvent:(UIEvent*)event {
    [self.trackTimer invalidate];
    self.trackTimer = nil;
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.bPlace];
    if(point.x > self.bPlace.frame.size.width)
        point.x = self.bPlace.frame.size.width;
    [AnimationManager constraintMoveAnimationWithView:self.bPlace constraint:self.bProgressWidthConstraint duration:0 constraintPosition:point.x];
    NSTimeInterval time = self.bProgressWidthConstraint.constant/self.bPlace.frame.size.width * self.audioPlayer.audioPlayer.duration;
    self.lbTimeLeft.text = [self.timeManager dateFormatSecondsToMinutes:time];
}
- (void) setTimeAfterDrag:(id)sender withEvent:(UIEvent*)event {
    NSTimeInterval time = self.bProgressWidthConstraint.constant/self.bPlace.frame.size.width * self.audioPlayer.audioPlayer.duration;
    [self.audioPlayer.audioPlayer setCurrentTime:time];
    if(!self.trackTimer)
        self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackProgress) userInfo:nil repeats:YES];
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
    float multiplier = ([self.audioPlayer.audioPlayer currentTime]/[self.audioPlayer.audioPlayer duration]) * self.bPlace.frame.size.width;
    [AnimationManager constraintMoveAnimationWithView:self.bPlace constraint:self.bProgressWidthConstraint duration:0 constraintPosition:multiplier];
    [self setTime];
    if(!self.audioPlayer.audioPlayer.isPlaying){
        [self.trackTimer invalidate];
        self.trackTimer = nil;
        [self.bPlay setTitle:@"Play" forState:(UIControlStateNormal)];
    }
}
- (void) setTime {
    self.lbTimeLeft.text = [self.timeManager dateFormatSecondsToMinutes:[self.audioPlayer.audioPlayer currentTime]];
    self.lbTimeRight.text = [self.timeManager dateFormatSecondsToMinutes:[self.audioPlayer.audioPlayer duration]];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        [LandscapeManager toLandscapeVC:self];
    }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
    }];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self trackProgress];
    [LandscapeManager toLandscapeVC:self];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
@end
