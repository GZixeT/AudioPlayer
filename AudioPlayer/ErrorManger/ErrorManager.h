//
//  ErrorManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorManager : NSObject
+ (void) errorWithTitle:(NSString*)title message:(NSString*)message;
@end
