//
//  RTCell.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 24/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "AudioManager.h"
#import "AudioPlayer.h"
#import "AlertManager.h"
#import "RTCell.h"

@implementation RTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void) play {
    NSError *error = nil;
    [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithFilePath:self.filePath error:&error];
    if(!error) {
        [AudioPlayer sharedInstance].artist = @"Recorder";
        [AudioPlayer sharedInstance].title = self.lbSongsName.text;
        [AudioPlayer sharedInstance].artwork = nil;
        [[AudioPlayer sharedInstance].audioPlayer play];
        [self.delegate goToViewController];
    } else [AlertManager alertWithTitle:@"Ошибка" message:@"Ошибка воспроизведения"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        [self play];
    }
    // Configure the view for the selected state
}

@end
