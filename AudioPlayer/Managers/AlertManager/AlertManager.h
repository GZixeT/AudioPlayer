//
//  ErrorManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertManager : NSObject
+ (void) alertWithTitle:(NSString*)title message:(NSString*)message;
+ (void) alertForActionWithTitle:(NSString*)title message:(NSString*)message action:(void(^)(void))bAction;
@end
