//
//  VCAudioPlayer.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCAudioPlayer : UIViewController 
@property (weak, nonatomic) IBOutlet UILabel *lbArtistAndSong;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbTimeRight;
@property (weak, nonatomic) IBOutlet UIButton *bPlay;
@property (weak, nonatomic) IBOutlet UIProgressView *pbAudioTrack;
@property (strong, nonatomic) IBOutlet UILabel *lbTimeLeft;
@end
