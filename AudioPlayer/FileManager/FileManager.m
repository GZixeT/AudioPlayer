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
+ (NSArray*) getFileNamesMp3WithPath:(NSString*)path {
    NSMutableArray *f = [[NSMutableArray alloc] init];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"mp3"]) {
            [f addObject:[path stringByAppendingPathComponent:filename]];
        }
    }];
    return f;
}
+ (void) getAsyncFileNamesWithPath:(NSString*)path handler:(void(^)(NSArray*))files {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [self getFileNamesWithPath:path];
        files(array);
    });
}
+ (void) getAsyncFileNamesMp3WithPath:(NSString*)path handler:(void(^)(NSArray*))files {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        files([self getFileNamesMp3WithPath:path]);
    });
}
@end
