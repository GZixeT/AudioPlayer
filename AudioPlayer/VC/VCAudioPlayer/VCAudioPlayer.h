//
//  VCAudioPlayer.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PlayTypeAll,
    PlayTypeSingle,
    PlayTypePlayList
}PlayType;

@interface VCAudioPlayer : UIViewController 
@property (weak, nonatomic) IBOutlet UIButton *bProgress;
@property (weak, nonatomic) IBOutlet UILabel *lbArtistAndSong;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbTimeRight;
@property (weak, nonatomic) IBOutlet UIButton *bPlay;
@property (strong, nonatomic) IBOutlet UILabel *lbTimeLeft;
@property PlayType playType;
@end
