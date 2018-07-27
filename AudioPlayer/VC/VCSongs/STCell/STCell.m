//
//  STCell.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 24/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "AudioManager.h"
#import "AudioPlayer.h"
#import "STCell.h"

@implementation STCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void) play {
    if([AudioPlayer sharedInstance].audioPlayer.isPlaying) {
        if([self.pathOrURL isKindOfClass:[NSURL class]]) {
            if(![[AudioPlayer sharedInstance].audioPlayer.url isEqual:self.pathOrURL]){
                [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithURL:self.pathOrURL error:nil];
            }
        }//kind of
        if([self.pathOrURL isKindOfClass:[NSString class]]) {
            if(![[AudioPlayer sharedInstance].audioPlayer.url.absoluteString isEqual:self.pathOrURL]){
                [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithFilePath:self.pathOrURL error:nil];
            }
        }//kind of
    }
    else {
        if([self.pathOrURL isKindOfClass:[NSURL class]]) {
            [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithURL:self.pathOrURL error:nil];
        }
        else  [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithFilePath:self.pathOrURL error:nil];
    }
    [AudioPlayer sharedInstance].title = self.lbSongsName.text;
    [AudioPlayer sharedInstance].artist = self.lbArtistName.text;
    [AudioPlayer sharedInstance].artwork = self.artwork;
    [AudioPlayer sharedInstance].playlistPosition = self.indexPath.row;
    [[AudioPlayer sharedInstance].audioPlayer play];
    [self.delegate goToViewController];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        [self play];
    }//selected
}

@end
