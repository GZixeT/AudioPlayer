//
//  FMTable.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 20/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#define NUMBER_OF_SECTIONS 1
#define ROW_HEIGHT 70
#define LAST_DIRECTORY_NUMBER 0
#define FMTCELL_ID @"FMTCell_Standart"
#import "FMTable.h"
#import "FMTCell.h"
#import "FileManager.h"
@interface FMTable() <UITableViewDelegate, UITableViewDataSource, FMTCellDelegate>
@property NSArray *pathArray;
@property NSArray *fileNames;
@property NSString *currentPath;
@property NSIndexPath *lastPlaying;
@end

@implementation FMTable
- (void) initTableParams {
    self.lastPlaying = nil;
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [[UIView alloc]init];
    self.currentPath = [[NSBundle mainBundle]resourcePath];
    [self setFilePaths];
}
- (void) setFilePaths {
    self.pathArray = [FileManager getFilePaths:self.currentPath];
    self.fileNames = [FileManager getFileNamesWithPath:self.currentPath];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pathArray.count + 1;
}
- (void) goToLastDirectory {
    self.currentPath = [FileManager getLastDirectoryPath:self.currentPath];
    [self setFilePaths];
    [self reloadData];
}
- (void) goToNextDirectoryWithIndexPath:(NSIndexPath*)indexPath {
    FMTCell *cell = [self cellForRowAtIndexPath:indexPath];
    self.currentPath = [NSString stringWithFormat:@"%@/%@",self.currentPath,cell.lbFileName.text];
    [self setFilePaths];
    [self reloadData];
}
- (void) setLastPlayingCell:(NSIndexPath *)indexPath  {
    if(self.lastPlaying && self.lastPlaying !=indexPath) {
        FMTCell *cell = [self cellForRowAtIndexPath:self.lastPlaying];
        [cell stop];
    }
    self.lastPlaying = indexPath;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTCell *cell = [tableView dequeueReusableCellWithIdentifier:FMTCELL_ID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if(indexPath.row == LAST_DIRECTORY_NUMBER){
        cell.lbFileName .text = [NSString stringWithFormat:@"...%@",[FileManager getDirectoryName:self.currentPath]];
        cell.path = [FileManager getLastDirectoryPath:self.currentPath];
        [cell setButtonTypeLastDirectory];
    } else {
        cell.lbFileName .text = self.fileNames[indexPath.row - 1];
        cell.path = self.pathArray[indexPath.row - 1];
        [cell setButtonTypeWithPath:self.fileNames[indexPath.row -1]];
    }
    cell.delegate = self;
    self.rowHeight = ROW_HEIGHT;
    return cell;
}


@end
