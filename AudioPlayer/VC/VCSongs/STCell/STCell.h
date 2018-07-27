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
@property NSIndexPath *indexPath;
@end

@protocol STCellDelegate
@optional
- (void) goToViewController;
- (void) goToViewControllerWithPosition:(NSInteger)position;
@end
