//
//  AppManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 23/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#define MAIN_APP_FOLDER_NAME @"AudioPlayerGZ"
#define STANDRT_RECORD_FOLDER_NAME @"records"
#define STANDART_RECORD_BASIC_PATH [NSString stringWithFormat:@"%@/%@",MAIN_APP_FOLDER_NAME,STANDRT_RECORD_FOLDER_NAME]
#define DOCUMENTS_FOLDER [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define MAIN_APP_FOLDER [DOCUMENTS_FOLDER stringByAppendingPathComponent:MAIN_APP_FOLDER_NAME]
#define STANDRT_RECORD_FOLDER [MAIN_APP_FOLDER stringByAppendingPathComponent:STANDRT_RECORD_FOLDER_NAME]
#import "FileManager.h"
#import "AppManager.h"
#import "RLMFolder.h"
#import "FileManager.h"
#import <Realm.h>

@implementation AppManager
+ (BOOL) isExistMainAppsFolders {
    return [RLMFolder objectForPrimaryKey:MAIN_APP_FOLDER_NAME] && [RLMFolder objectForPrimaryKey:STANDART_RECORD_BASIC_PATH];
}
+ (void) createMainAppsFolders {
    NSError *mainError = nil;
    NSError *recordsError = nil;
    [FileManager createDirectoryAtPath:[self mainAppFolder] error:&mainError];
    if(!mainError) {
        RLMFolder *main = [RLMFolder createRLMFolder:MAIN_APP_FOLDER_NAME];
        [self addObjectForRealm:main];
    }
    else NSLog(@"%@ error:%@",MAIN_APP_FOLDER,mainError);
    [FileManager createDirectoryAtPath:STANDRT_RECORD_FOLDER error:&recordsError];
    if(!recordsError) {
        RLMFolder *records = [RLMFolder createRLMFolder:STANDART_RECORD_BASIC_PATH];
        [self addObjectForRealm:records];
    }
    else NSLog(@"%@ error:%@",STANDRT_RECORD_FOLDER,recordsError);
}
+ (void) addObjectForRealm:(id)object {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:object];
    [realm commitWriteTransaction];
}
+ (void) addObjectsForRealm:(id)objects {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObjects:objects];
    [realm commitWriteTransaction];
}
+ (void) deleteObjectForRealm:(id)object {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:object];
    [realm commitWriteTransaction];
}
+ (void) deleteObjectsForRealm:(id)objects {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:objects];
    [realm commitWriteTransaction];
}
+ (NSString*) mainAppFolder {
    return MAIN_APP_FOLDER;
}
+ (NSString*) standartRecordFolder {
    return STANDRT_RECORD_FOLDER;
}
+ (void) deleteAllRLMLFolders {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *result = [RLMFolder allObjects];
    for(RLMFolder *folder in result) {
        NSError *error = nil;
        [FileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER,folder.folderName] error:&error];
    }
    [realm beginWriteTransaction];
    [realm deleteObjects:result];
    [realm commitWriteTransaction];
}
+ (void) deleteMainFolder {
    NSError *error = nil;
    [FileManager removeItemAtPath:MAIN_APP_FOLDER error:&error];
}
+ (NSString*) documentsFolder {
    return DOCUMENTS_FOLDER;
}
+ (NSString*) recordsBasicPath {
    return STANDART_RECORD_BASIC_PATH;
}
@end
