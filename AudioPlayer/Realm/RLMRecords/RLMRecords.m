//
//  RLMRecords.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 26/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import "RLMRecords.h"

@implementation RLMRecords
+ (instancetype) createRLMRecords:(NSString*)path {
    RLMRecords *item = [[RLMRecords alloc]init];
    item.path = path;
    return item;
}
+ (NSString*) primaryKey {
    return @"path";
}
@end
