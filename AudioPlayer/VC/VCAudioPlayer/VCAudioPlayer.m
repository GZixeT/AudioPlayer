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
#import <MediaPlayer/MediaPlayer.h>

@interface VCAudioPlayer () <UIGestureRecognizerDelegate, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bPlace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bProgressWidthConstraint;
@property TimeManager *timeManager;
@property AudioPlayer *audioPlayer;
@property NSTimer *trackTimer;
@end

@implementation VCAudioPlayer
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewParams];
    [self initViewGestures];
    [self initProgressEvents];
}
- (void) initViewParams {
    self.timeManager = [TimeManager sharedInstance];
    self.audioPlayer = [AudioPlayer sharedInstance];
    self.audioPlayer.audioPlayer.delegate = self;
    self.trackTimer = nil;
    if(self.audioPlayer.audioPlayer.isPlaying) {
        [self.bPlay setTitle:@"Stop" forState:(UIControlStateNormal)];
        if(!self.trackTimer)
            self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackProgress) userInfo:nil repeats:YES];
    }
    else {
        self.trackTimer = nil;
        [self.trackTimer invalidate];
        [self.bPlay setTitle:@"Play" forState:(UIControlStateNormal)];
    }
    self.navigationItem.title = @"Плеер";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    if(self.audioPlayer.artist)
        self.lbArtistAndSong.text = [NSString stringWithFormat:@"%@ - %@",self.audioPlayer.artist, self.audioPlayer.title];
    else self.lbArtistAndSong.text = [NSString stringWithFormat:@"%@ - %@",@"Неизвестный исполнитель", self.audioPlayer.title];
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
    [self setTime];
}
- (void) initWillAppearViewParams {
    [self.trackTimer invalidate];
    self.trackTimer = nil;
    if(self.audioPlayer.audioPlayer.isPlaying) {
        [self.bPlay setTitle:@"Stop" forState:(UIControlStateNormal)];
        if(!self.trackTimer)
            self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackProgress) userInfo:nil repeats:YES];
    }
    else {
        self.trackTimer = nil;
        [self.trackTimer invalidate];
        [self.bPlay setTitle:@"Play" forState:(UIControlStateNormal)];
    }
    if(self.audioPlayer.artwork){
        [self.artworkImageView setImage:self.audioPlayer.artwork];
    } else {
        self.artworkImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.artworkImageView setImage:[UIImage imageNamed:@"musical-note"]];
    }
    [self setTime];
    if(self.audioPlayer.artist)
        self.lbArtistAndSong.text = [NSString stringWithFormat:@"%@ - %@",self.audioPlayer.artist, self.audioPlayer.title];
    else self.lbArtistAndSong.text = [NSString stringWithFormat:@"%@ - %@",@"Неизвестный исполнитель", self.audioPlayer.title];
}
- (void) initProgressEvents {
    [self.bPlace addTarget:self action:@selector(setTimeAfterDrag:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bProgress  addTarget:self action:@selector(setTimeAfterDrag:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bPlace addTarget:self action:@selector(bDragMove:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.bProgress  addTarget:self action:@selector(bDragMove:withEvent:) forControlEvents:UIControlEventTouchDragInside];
}
- (void) initViewGestures {
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeL];
    [self.view addGestureRecognizer:swipeR];
}
- (void) swipeLeft {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.view.window.layer addAnimation:[AnimationManager transitionAnimationBeforViewDisappearWithType:GesturesAnimationSwipeRight] forKey:nil];
}
- (void) swipeRight {
    NSInteger last = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:last - 1] animated:YES];
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
    if(!self.audioPlayer.audioPlayer.isPlaying && self.trackTimer) {
        
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
    [LandscapeManager toLandscapeVC:self];
    [self initWillAppearViewParams];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self trackProgress];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    MPMediaItem *item = nil;
    switch (self.audioPlayer.playType) {
        case PlayTypeAll: {
            MPMediaQuery *query = [MPMediaQuery songsQuery];
            NSArray *array = query.items;
            if(array.count - 1 > self.audioPlayer.playlistPosition) {
                self.audioPlayer.playlistPosition++;
            } else {
                self.audioPlayer.playlistPosition = 0;
            }
            item = array[self.audioPlayer.playlistPosition];
        }
            break;
        case PlayTypeSingle:
            break;
        case PlayTypePlayList:
            break;
        default:
            break;
    }
    [AudioManager setSessionCategoryForMultiRouteWithError:nil];
    NSLog(@"PlaylistPosition:%d",(int)self.audioPlayer.playlistPosition);
    self.audioPlayer.audioPlayer = [AudioManager createAudioPlayerWithURL:item.assetURL error:nil];
    self.audioPlayer.audioPlayer.delegate = self;
    self.audioPlayer.title = item.title;
    self.audioPlayer.artist = item.artist;
    self.audioPlayer.artwork = [item.artwork imageWithSize:[item.artwork imageCropRect].size];
    if(item.artist)
        self.lbArtistAndSong.text = [NSString stringWithFormat:@"%@ - %@",item.artist, item.title];
    else self.lbArtistAndSong.text = [NSString stringWithFormat:@"%@ - %@",@"Неизвестный исполнитель", item.title];
    if(item.artwork){
        [self.artworkImageView setImage:[item.artwork imageWithSize:[item.artwork imageCropRect].size]];
    } else {
        self.artworkImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.artworkImageView setImage:[UIImage imageNamed:@"musical-note"]];
    }
    [self.audioPlayer.audioPlayer play];
}
@end
