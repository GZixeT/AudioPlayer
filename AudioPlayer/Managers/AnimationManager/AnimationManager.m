//
//  AnimationManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 26/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager
+ (void) constraintMoveAnimationWithView:(UIView*)view constraint:(NSLayoutConstraint*)constraint duration:(double)duration constraintPosition:(CGFloat)position {
    if(position < 0)position = 0;
    [view layoutIfNeeded];
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    constraint.constant = position;
    [view layoutIfNeeded];
    [CATransaction commit];
}
@end
