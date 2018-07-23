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
#import "AppManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FMTable() <UITableViewDelegate, UITableViewDataSource, FMTCellDelegate>
@property NSArray *pathArray;
@property NSArray *fileNames;
@property NSString *currentPath;
@property NSIndexPath *lastPlaying;
@property NSArray *songs;
@end

@implementation FMTable
- (void) initTableParams {
    self.lastPlaying = nil;
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [[UIView alloc]init];
    self.currentPath = [AppManager mainAppFolder];
}
- (void) setAllMedia {
    MPMediaQuery *qu = [MPMediaQuery songsQuery];
    self.songs = qu.items;
}
- (void) setFilePaths {
    NSArray *array = [FileManager getFilePaths:self.currentPath];
    self.pathArray = [self filter:array];
    self.fileNames = [self fileNamesAtPathArray:self.pathArray];
}
- (NSArray*) fileNamesAtPathArray:(NSArray*)paths {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for(NSString* path in paths) {
        [names addObject:[path lastPathComponent]];
    }
    return names;
}
- (NSArray*) filter:(NSArray*)array {
    NSMutableArray *folders = [[NSMutableArray alloc] init];
    NSMutableArray *files  = [[NSMutableArray alloc] init];
    for(NSString *path in array) {
        if([[path pathExtension]isEqualToString:@""]){
            [folders addObject:path];
        } else if([[path pathExtension]isEqualToString:@"mp3"]){
            [files addObject:path];
        } else if([[path pathExtension]isEqualToString:@"caf"]){
            [files addObject:path];
        }
    }
    NSMutableArray *narray = [[NSMutableArray alloc] init];
    [narray addObjectsFromArray:folders];
    [narray addObjectsFromArray:files];
    return narray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.songs) return self.songs.count;
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
- (void) goToAudioPlayer {
    [self.fmdelegate openVCAudioPlayer];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTCell *cell = [tableView dequeueReusableCellWithIdentifier:FMTCELL_ID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if(self.songs) {
        [self initAllMediaTypeCellAtIndexPath:indexPath cell:cell];
    } else if (self.pathArray) {
        [self initFolderTypeCellAtIndexPath:indexPath cell:cell];
    }
    cell.delegate = self;
    self.rowHeight = ROW_HEIGHT;
    return cell;
}
- (void) initFolderTypeCellAtIndexPath:(NSIndexPath*)indexPath cell:(FMTCell*)cell {
    if(indexPath.row == LAST_DIRECTORY_NUMBER){
        cell.lbFileName .text = [NSString stringWithFormat:@"...%@",[FileManager getDirectoryName:self.currentPath]];
        cell.path = [FileManager getLastDirectoryPath:self.currentPath];
        [cell setButtonTypeLastDirectory];
    } else {
        cell.lbFileName .text = self.fileNames[indexPath.row - 1];
        cell.path = self.pathArray[indexPath.row - 1];
        [cell setButtonTypeWithPath:self.fileNames[indexPath.row -1]];
    }
}
- (void) initAllMediaTypeCellAtIndexPath:(NSIndexPath*)indexPath cell:(FMTCell*)cell {
    MPMediaItem *item = self.songs[indexPath.row];
    cell.lbFileName.text = [NSString stringWithFormat:@"%@ - %@",item.artist,item.title];
    cell.path = item.assetURL;
    [cell setButtonPlayType];
}
@end
