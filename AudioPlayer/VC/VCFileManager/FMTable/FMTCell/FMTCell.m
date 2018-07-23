//
//  FMTCell.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 20/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "AudioManager.h"
#import "AudioPlayer.h"
#import "FileManager.h"
#import "FMTCell.h"

@interface FMTCell() <AVAudioPlayerDelegate>
@property ButtonType btype;
@property BOOL buttonAction;
@end

@implementation FMTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btype = ButtonTypeBlank;
}
- (void) setButtonTypeLastDirectory {
    self.btype = ButtonTypeLastDirectory;
    [self.bAction setTitle:@"Back" forState:(UIControlStateNormal)];
}
- (void) setButtonTypeWithPath:(NSString*)path {
    if([FileManager isMP3Extension:path] || [FileManager isCafExtension:path]){
        if([AudioPlayer sharedInstance].audioPlayer.isPlaying) {
            [self.bAction setTitle:@"Stop" forState:(UIControlStateNormal)];
            self.btype = ButtonTypePlayerStop;
        } else {
            [self.bAction setTitle:@"Play" forState:(UIControlStateNormal)];
            self.btype = ButtonTypePlayerPlay;
        }
    }
    else if ([FileManager isDirectoryExtension:path]) {
        [self.bAction setTitle:@"Go" forState:(UIControlStateNormal)];
        self.btype = ButtonTypeDirectory;
    }
    else{
        [self.bAction setTitle:@"" forState:(UIControlStateNormal)];
        self.btype = ButtonTypeBlank;
    }
}
- (void) setButtonPlayType {
    if([AudioPlayer sharedInstance].audioPlayer.isPlaying) {
        [self.bAction setTitle:@"Stop" forState:(UIControlStateNormal)];
        self.btype = ButtonTypePlayerStop;
    } else {
        [self.bAction setTitle:@"Play" forState:(UIControlStateNormal)];
        self.btype = ButtonTypePlayerPlay;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected)
        [self action];
    // Configure the view for the selected state
}

- (IBAction)bAction:(id)sender {
    self.buttonAction = YES;
    [self action];
}
- (void) stop {
    [self.bAction setTitle:@"Play" forState:(UIControlStateNormal)];
    self.btype = ButtonTypePlayerPlay;
    [[AudioPlayer sharedInstance].audioPlayer stop];
}
- (void) play {
    [self.delegate setLastPlayingCell:self.indexPath];
    [self.bAction setTitle:@"Stop" forState:(UIControlStateNormal)];
    if([self.path isKindOfClass:[NSString class]]) {
        [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithFilePath:self.path error:nil];
    } else if([self.path isKindOfClass:[NSURL class]]) {
        [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithURL:self.path error:nil];
    }
    [[AudioPlayer sharedInstance].audioPlayer play];
    self.btype = ButtonTypePlayerStop;
}
- (void) action {
    switch (self.btype) {
        case ButtonTypeDirectory:
            [self.delegate goToNextDirectoryWithIndexPath:self.indexPath];
            break;
        case ButtonTypePlayerPlay:
            [self play];
            if(self.selected)[self.delegate goToAudioPlayer];
            break;
        case ButtonTypePlayerStop:
            if(self.selected && !self.buttonAction){
                [self.delegate goToAudioPlayer];
                break;
            }
            [self stop];
            break;
        case ButtonTypeLastDirectory:
            [self.delegate goToLastDirectory];
            break;
        default:
            break;
    }
    self.buttonAction = NO;
}
@end
