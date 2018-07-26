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
+ (void) deleteObjectForRealm:(id)object;
+ (void) deleteAllRLMLFolders;
+ (void) deleteMainFolder;
+ (NSString*) mainAppFolder;
+ (NSString*) standartRecordFolder;
+ (NSString*) documentsFolder;
+ (NSString*) recordsBasicPath;
@end
