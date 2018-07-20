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
+ (NSArray*) getFileNamesMP3andCAFWithPath:(NSString*)path;
+ (NSArray*) getFilePaths:(NSString*)path;
+ (BOOL) isMP3Extension:(NSString*)path;
+ (BOOL) isCafExtension:(NSString*)path;
+ (BOOL) isDirectoryExtension:(NSString*)path;
+ (BOOL) findInDirectory:(NSString*)path fileName:(NSString*)fileName;
+ (void) getAsyncFileNamesWithPath:(NSString*)path handler:(void(^)(NSArray*))files;
+ (void) getAsyncFileNamesMP3andCAFWithPath:(NSString*)path handler:(void(^)(NSArray*))files;
+ (NSString*) getLastDirectoryPath:(NSString*)path;
+ (NSString*) getDirectoryName:(NSString*)path;
@end
