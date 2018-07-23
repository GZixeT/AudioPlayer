//
//  RLMFolder.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 23/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import "RLMObject.h"

@interface RLMFolder : RLMObject
@property NSString *folderName;
+ (instancetype) createRLMFolder: (NSString*)folderName;
@end
