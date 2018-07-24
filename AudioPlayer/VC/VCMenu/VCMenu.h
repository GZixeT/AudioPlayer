//
//  VCMenu.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 23/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCMenu : UIViewController
@property (weak, nonatomic) IBOutlet UIView *vGradient;
@property (weak, nonatomic) IBOutlet UIButton *bPlay;
@property (weak, nonatomic) IBOutlet UILabel *lbArtistName;
@property (weak, nonatomic) IBOutlet UILabel *lbSongName;
@property (weak, nonatomic) IBOutlet UIButton *bItunes;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@end
