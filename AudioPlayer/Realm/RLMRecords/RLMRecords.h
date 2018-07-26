//
//  RLMRecords.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 26/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import "RLMObject.h"

@interface RLMRecords : RLMObject
@property NSString *path;
+ (instancetype) createRLMRecords:(NSString*)path;
@end
