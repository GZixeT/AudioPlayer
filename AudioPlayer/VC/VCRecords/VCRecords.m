//
//  VCRecords.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 24/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#define CELL_ID @"RTCell_ID"
#define NUMBER_OF_SECTIONS 1
#import "VCRecords.h"
#import "FileManager.h"
#import "AppManager.h"
#import "RTCell.h"
#import "VCAudioPlayer.h"
#import "AlertManager.h"
#import <Realm.h>
#import "RLMFolder.h"
#import "AppManager.h"
#import "RLMRecords.h"

@interface VCRecords () <UITableViewDelegate, UITableViewDataSource, RTCellDelegate>
@property NSMutableArray *recordsNames;
@property NSMutableArray *recordsPaths;
@end

@implementation VCRecords
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableRecords.delegate = self;
    self.tableRecords.dataSource = self;
    self.tableRecords.tableFooterView = [[UIView alloc]init];
    self.navigationItem.title = @"Записи";
    NSArray *paths = [FileManager getFilePaths:[AppManager standartRecordFolder]];
    self.recordsNames = (NSMutableArray*)[self filter:paths nameOrPath:NO];
    self.recordsPaths = (NSMutableArray*)[self filter:paths nameOrPath:YES];
}
- (NSArray*) filter:(NSArray*)array nameOrPath:(BOOL)nameOrPath{
    NSMutableArray *mut = [[NSMutableArray alloc]init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = (NSString*)obj;
        if([FileManager isCafExtension:path] && !nameOrPath) {
                [mut addObject:[path lastPathComponent]];
        }
        else if(nameOrPath) [mut addObject:path];
    }];
    return mut;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordsPaths.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    cell.lbSongsName.text = self.recordsNames[indexPath.row];
    cell.filePath = self.recordsPaths[indexPath.row];
    cell.delegate = self;
    self.tableRecords.rowHeight = 70;
    return cell;
}
- (void) goToViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioPlayer *audioPlayer = [storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
    [self.navigationController pushViewController:audioPlayer animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [AlertManager alertForActionWithTitle:@"Внимание" message:@"Удалить файл?" action:^{
            NSError *error = nil;
            [FileManager removeItemAtPath:cell.filePath error:&error];
            if(!error) {
                [AppManager deleteObjectForRealm:[RLMRecords objectForPrimaryKey:[NSString stringWithFormat:@"%@/%@",[AppManager recordsBasicPath],cell.lbSongsName.text]]];
                [self.recordsPaths removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
            }
        }];
    }];
    UITableViewRowAction *share = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@",cell.lbSongsName.text]]];
        NSData *cafData = [NSData dataWithContentsOfFile:cell.filePath];
        [cafData writeToURL:url atomically:NO];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        [self.navigationController presentViewController:activityViewController animated:YES completion:^{}];
    }];
    delete.backgroundColor = [UIColor redColor];
    return @[delete,share];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
