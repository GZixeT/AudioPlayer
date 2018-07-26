//
//  LandscapeManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 26/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "VCLanscape.h"
#import <UIKit/UIKit.h>

@interface LandscapeManager : NSObject
+ (BOOL) isPortraitOrientation;
+ (void) toLandscapeVC:(UIViewController*)vc;
@end
