//
//  VCFileManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "FileManager.h"
#import "VCFileManager.h"

@interface VCFileManager ()
@property NSArray *files;
@property NSArray *mp3files;
@end

@implementation VCFileManager

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"File manager";
    self.files = [FileManager getFileNamesWithPath:[[NSBundle mainBundle]resourcePath]];
    self.mp3files = [FileManager getFileNamesMp3WithPath:[[NSBundle mainBundle]resourcePath]];
    NSLog(@"%@",self.files);
    NSLog(@"%@",self.mp3files);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
