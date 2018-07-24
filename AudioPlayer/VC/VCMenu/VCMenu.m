//
//  VCMenu.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 23/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "VCMenu.h"
#import "VCAudioRecorder.h"
#import "VCSongs.h"
#import "AudioPlayer.h"
@interface VCMenu ()
@property CAGradientLayer *gradient;
@end

@implementation VCMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(goToRecord)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = @"Плеер";
    self.bPlay.layer.cornerRadius = 10;
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
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        self.gradient.frame = self.vGradient.bounds;
    }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
        
    }];
}
- (void) setGradient {
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.vGradient.bounds;
    self.gradient.colors = @[(id)[UIColor grayColor].CGColor,(id)[UIColor colorWithWhite:0 alpha:0]];
    self.gradient.startPoint = CGPointMake(0, 1);
    self.gradient.endPoint = CGPointMake(0, 0);
    [self.vGradient.layer insertSublayer:self.gradient atIndex:0];
    //[self.vGradient.layer addSublayer:gradient];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setGradient];
    if(![AudioPlayer sharedInstance].audioPlayer){
        self.bPlay.hidden = YES;
        self.lbSongName.text = @"";
        self.lbArtistName.text = @"";
    }
    else {
        if([AudioPlayer sharedInstance].artwork) {
            [self.artworkImage setImage:[AudioPlayer sharedInstance].artwork];
        }else {}
        self.lbArtistName.text = [AudioPlayer sharedInstance].artist;
        self.lbSongName.text = [AudioPlayer sharedInstance].title;
        if([AudioPlayer sharedInstance].audioPlayer.isPlaying) {
            [self.bPlay setTitle:@"Stop" forState:(UIControlStateNormal)];
        }
        else [self.bPlay setTitle:@"Play" forState:(UIControlStateNormal)];
        self.bPlay.hidden = NO;
    }
}
- (void) goToVCSongs {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCSongs *songs = [storyboard instantiateViewControllerWithIdentifier:@"Songs"];
    [self.navigationController pushViewController:songs animated:YES];
}
- (IBAction)bItunesAction:(id)sender {
    [self goToVCSongs];
}
- (IBAction)bPlayAction:(id)sender {
    if([AudioPlayer sharedInstance].audioPlayer.isPlaying){
        [[AudioPlayer sharedInstance].audioPlayer stop];
        [self.bPlay setTitle:@"Play" forState:(UIControlStateNormal)];
    } else {
        [[AudioPlayer sharedInstance].audioPlayer play];
        [self.bPlay setTitle:@"Stop" forState:(UIControlStateNormal)];
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
