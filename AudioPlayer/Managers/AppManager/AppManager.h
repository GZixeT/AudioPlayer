//
//  AppManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 23/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface AppManager : NSObject
+ (BOOL) isExistMainAppsFolders;
+ (void) createMainAppsFolders;
+ (void) addObjectForRealm:(id)object;
+ (void) addObjectsForRealm:(id)objects;
+ (void) deleteObjectForRealm:(id)object;
+ (void) deleteObjectsForRealm:(id)objects;
+ (void) deleteAllRLMLFolders;
+ (void) deleteMainFolder;
+ (NSString*) mainAppFolder;
+ (NSString*) standartRecordFolder;
+ (NSString*) documentsFolder;
+ (NSString*) recordsBasicPath;
@end
