//
//  STCell.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 24/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STCellDelegate;
@interface STCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbArtistName;
@property (weak, nonatomic) IBOutlet UILabel *lbSongsName;
@property UIImage *artwork;
@property id <STCellDelegate> delegate;
@property id pathOrURL;
@end

@protocol STCellDelegate
@optional
- (void) goToViewController;
@end
