//
//  TimeManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 25/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#define SECONDS_FORMAT @"ss"
#define MINUTES_FORMAT @"mm:ss"

#import "TimeManager.h"

static TimeManager *sharedInstance;
@implementation TimeManager
+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TimeManager alloc]init];
    });
    return sharedInstance;
}
- (instancetype) init {
    if(self = [super init]) {
        self.formater = [[NSDateFormatter alloc]init];
    }
    return self;
}
- (NSString*) dateFormatSecondsToMinutes:(double)seconds {
    [self.formater setDateFormat:MINUTES_FORMAT];
    float min = floorf(fmod(seconds, 60*60)/60);
    float nseconds = seconds - min*60;
    NSString *minutesString = [NSString stringWithFormat:@"%d:%d",(int)min,(int)nseconds];
    NSDate *minutesDate = [self.formater dateFromString:minutesString];
    return [self.formater stringFromDate:minutesDate];
}
@end
