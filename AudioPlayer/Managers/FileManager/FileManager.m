//
//  FileManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager
+ (NSArray*) getFileNamesWithPath:(NSString*)path {
    NSMutableArray *f = [[NSMutableArray alloc] init];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        [f addObject:filename];
    }];
    return f;
}
+ (NSArray*) getFileNamesMP3andCAFWithPath:(NSString*)path {
    NSMutableArray *f = [[NSMutableArray alloc] init];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"mp3"]) {
            [f addObject:[path stringByAppendingPathComponent:filename]];
        }
        if ([extension isEqualToString:@"caf"]) {
            [f addObject:[path stringByAppendingPathComponent:filename]];
        }
    }];
    return f;
}
+ (NSArray*) getFilePaths:(NSString*)path {
    NSMutableArray *f = [[NSMutableArray alloc] init];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *pathFile = [NSString stringWithFormat:@"%@/%@",path,filename];
        [f addObject:pathFile];
    }];
    return f;
}
+ (void) getAsyncFileNamesWithPath:(NSString*)path handler:(void(^)(NSArray*))files {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [self getFileNamesWithPath:path];
        files(array);
    });
}
+ (void) getAsyncFileNamesMP3andCAFWithPath:(NSString*)path handler:(void(^)(NSArray*))files {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        files([self getFileNamesMP3andCAFWithPath:path]);
    });
}
+ (BOOL) findInDirectory:(NSString*)path fileName:(NSString*)fileName {
    NSArray *names = [self getFileNamesWithPath:path];
    for(NSString *name in names){
        if(name == fileName)return YES;
    }
    return NO;
}
+ (BOOL) isMP3Extension:(NSString*)path {
    if([[path pathExtension]isEqualToString:@"mp3"])
        return YES;
    return NO;
}
+ (BOOL) isCafExtension:(NSString*)path {
    if([[path pathExtension]isEqualToString:@"caf"])
        return YES;
    return NO;
}
+ (BOOL) isDirectoryExtension:(NSString*)path {
    if([[path pathExtension]isEqualToString:@""])
        return YES;
    return NO;
}
+ (NSString*) getLastDirectoryPath:(NSString*)path {
    return [path stringByDeletingLastPathComponent];
}
+ (NSString*) getDirectoryName:(NSString*)path {
    return [path lastPathComponent];
}
+ (void) createDirectoryAtPath:(NSString*)path error:(NSError**)outError {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    if(error) {
        if(outError)
            *outError = error;
    }
}
+ (void) removeItemAtPath:(NSString*)path error:(NSError**)outError {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if(error) {
        if(outError)
            *outError = error;
    }
}
@end
