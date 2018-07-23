//
//  VCFileManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "AudioManager.h"
#import "VCFileManager.h"
#import "VCAudioPlayer.h"

@interface VCFileManager () <FMTableDelegate>
@end

@implementation VCFileManager

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"File manager";
    [self.fmtable initTableParams];
    [self initTableWithType];
    self.fmtable.fmdelegate = self;
    NSError *sessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [audioSession setActive:YES error:nil];
    // Do any additional setup after loading the view.
}
- (void) openVCAudioPlayer {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioPlayer *audioPlayer = [storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
    [self.navigationController pushViewController:audioPlayer animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initTableWithType {
    switch (self.type) {
        case ManagerTypeAllMedia:
            [self.fmtable setAllMedia];
            break;
        case ManagerTypeFolders:
            [self.fmtable setFilePaths];
            break;
        case ManagerTypeRecords:
            break;
            
        default:
            break;
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
