//
//  FMTCell.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 20/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ButtonTypePlayerPlay,
    ButtonTypePlayerStop,
    ButtonTypeDirectory,
    ButtonTypeBlank,
    ButtonTypeLastDirectory
}ButtonType;

@protocol FMTCellDelegate;

@interface FMTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bAction;
@property (weak, nonatomic) IBOutlet UILabel *lbFileName;
@property id path;
@property NSIndexPath *indexPath;
@property id <FMTCellDelegate> delegate;
- (void) setButtonTypeWithPath:(NSString*)path;
- (void) setButtonTypeLastDirectory;
- (void) setButtonPlayType;
- (void) action;
- (void) stop;
- (void) play;
@end

@protocol FMTCellDelegate
@optional
- (void) setLastPlayingCell:(NSIndexPath*)indexPath;
- (void) goToNextDirectoryWithIndexPath:(NSIndexPath*)indexPath;
- (void) goToLastDirectory;
- (void) goToAudioPlayer;
@end