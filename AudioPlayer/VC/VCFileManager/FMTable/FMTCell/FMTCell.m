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
        [self.bAction setTitle:@"Play" forState:(UIControlStateNormal)];
        self.btype = ButtonTypePlayerPlay;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected)
        [self typeAction];
    // Configure the view for the selected state
}

- (IBAction)bAction:(id)sender {
    [self typeAction];
}
- (void) typeAction {
    switch (self.btype) {
        case ButtonTypeDirectory:
            [self.delegate goToNextDirectoryWithIndexPath:self.indexPath];
            break;
        case ButtonTypePlayerPlay:{
            NSError *sessionError = nil;
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
            [self.bAction setTitle:@"Stop" forState:(UIControlStateNormal)];
            [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithFilePath:self.path error:nil];
            [[AudioPlayer sharedInstance].audioPlayer play];
            self.btype = ButtonTypePlayerStop;
        }
            break;
        case ButtonTypePlayerStop:
            [self.bAction setTitle:@"Play" forState:(UIControlStateNormal)];
            self.btype = ButtonTypePlayerPlay;
            [[AudioPlayer sharedInstance].audioPlayer stop];
            break;
        case ButtonTypeLastDirectory:
            [self.delegate goToLastDirectory];
            break;
        default:
            break;
    }
}
@end
