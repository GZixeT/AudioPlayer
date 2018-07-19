//
//  VCAudioRecorder.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCAudioRecorder : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *pbRecord;
@property (weak, nonatomic) IBOutlet UILabel *lbRecTime;
@property (weak, nonatomic) IBOutlet UIButton *bStopPlaying;
@property (weak, nonatomic) IBOutlet UIButton *bPlay;
@property (weak, nonatomic) IBOutlet UIButton *bRec;
@property (weak, nonatomic) IBOutlet UILabel *lbPlayProgress;
@property (weak, nonatomic) IBOutlet UIButton *bStop;
@end
