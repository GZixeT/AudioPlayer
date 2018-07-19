//
//  FileManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
+ (NSArray*) getFileNamesWithPath:(NSString*)path;
+ (NSArray*) getFileNamesMp3WithPath:(NSString*)path;
+ (void) getAsyncFileNamesWithPath:(NSString*)path handler:(void(^)(NSArray*))files;
+ (void) getAsyncFileNamesMp3WithPath:(NSString*)path handler:(void(^)(NSArray*))files;
@end
