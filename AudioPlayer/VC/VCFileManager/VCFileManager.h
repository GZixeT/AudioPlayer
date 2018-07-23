//
//  VCFileManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "FMTable.h"
#import <UIKit/UIKit.h>

typedef enum {
    ManagerTypeRecords,
    ManagerTypeFolders,
    ManagerTypeAllMedia
} ManagerType;
@interface VCFileManager : UIViewController
@property (weak, nonatomic) IBOutlet FMTable *fmtable;
@property ManagerType type;
@end
