//
//  AnimationManager.h
//  AudioPlayer
//
//  Created by Георгий Зубков on 26/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum{
    GesturesAnimationSwipeLeft,
    GesturesAnimationSwipeRight
}GesturesAnimation;

@interface AnimationManager : NSObject
+ (void) constraintMoveAnimationWithView:(UIView*)view constraint:(NSLayoutConstraint*)constraint duration:(double)duration constraintPosition:(CGFloat)position;
+ (CATransition*) transitionAnimationBeforViewDisappearWithType:(GesturesAnimation)animation;
@end
