//
//  TimeManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 25/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject
@property NSDateFormatter *formater;
+ (instancetype) sharedInstance;
- (NSString*) dateFormatSecondsToMinutes:(double)seconds;
@end
