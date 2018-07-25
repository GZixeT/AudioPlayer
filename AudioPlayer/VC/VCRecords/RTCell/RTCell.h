//
//  RTCell.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 24/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "STCell.h"
#import <UIKit/UIKit.h>

@protocol RTCellDelegate;
@interface RTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbSongsName;
@property id <RTCellDelegate> delegate;
@property NSString* filePath;
@end

@protocol RTCellDelegate
@optional
- (void) goToViewController;
@end
