//
//  FMTable.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 20/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FMTableDelegate;
@interface FMTable : UITableView
@property id <FMTableDelegate> fmdelegate;
- (void) initTableParams;
- (void) setAllMedia;
- (void) setFilePaths;
@end

@protocol FMTableDelegate
@optional
- (void) openVCAudioPlayer;
@end
