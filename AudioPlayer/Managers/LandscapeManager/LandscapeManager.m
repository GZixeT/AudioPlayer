//
//  LandscapeManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 26/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//

#import "LandscapeManager.h"

@implementation LandscapeManager
+ (BOOL) isPortraitOrientation {
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}
+ (void) toLandscapeVC:(UIViewController*)vc {
    if(![self isPortraitOrientation]) {
        if([vc isKindOfClass:[VCLandscape class]])return;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VCLandscape *landscape = [storyboard instantiateViewControllerWithIdentifier:@"VCLandscape"];
        [vc.navigationController pushViewController:landscape animated:YES];
    } else {
        if([vc isKindOfClass:[VCLandscape class]]) {
            NSInteger index = [[vc.navigationController viewControllers] indexOfObject:vc];
            [vc.navigationController popToViewController:[[vc.navigationController viewControllers] objectAtIndex:index -1] animated:YES];
        }
    }
}
@end
