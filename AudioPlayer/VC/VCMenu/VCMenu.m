//
//  VCMenu.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 23/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#import "VCMenu.h"
#import "VCAudioRecorder.h"
#import "VCFileManager.h"
@interface VCMenu ()

@end

@implementation VCMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(goToRecord)];
}
- (void) goToRecord {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioRecorder *recordView = [storyboard instantiateViewControllerWithIdentifier:@"AudioRecorder"];
    [self.navigationController pushViewController:recordView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bFileManagerAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCFileManager *fileMenager = [storyboard instantiateViewControllerWithIdentifier:@"FileManager"];
    fileMenager.type = ManagerTypeAllMedia;
    [self.navigationController pushViewController:fileMenager animated:YES];
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
