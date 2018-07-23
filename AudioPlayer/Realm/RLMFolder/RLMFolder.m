//
//  RLMFolder.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 23/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import "RLMFolder.h"

@implementation RLMFolder
+ (instancetype) createRLMFolder: (NSString*)folderName {
    RLMFolder *folder = [[RLMFolder alloc]init];
    folder.folderName = folderName;
    return folder;
}
+ (NSString*) primaryKey {
    return @"folderName";
}
@end
