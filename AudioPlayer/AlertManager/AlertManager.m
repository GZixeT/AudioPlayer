//
//  ErrorManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AlertManager.h"

@implementation AlertManager
+ (void) alertWithTitle:(NSString*)title message:(NSString*)message {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:ok];
    [controller presentViewController:alert animated:YES completion:^{}];
}
+ (void) alertForActionWithTitle:(NSString*)title message:(NSString*)message action:(void(^)(void))bAction {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if(bAction)
            bAction();
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:ok];
    [alert addAction:cancel];
    [controller presentViewController:alert animated:YES completion:^{}];
}
@end
