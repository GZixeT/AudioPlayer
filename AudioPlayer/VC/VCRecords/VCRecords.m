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

@interface VCRecords () <UITableViewDelegate, UITableViewDataSource, RTCellDelegate>
@property NSArray *recordsNames;
@property NSArray *recordsPaths;
@end

@implementation VCRecords
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableRecords.delegate = self;
    self.tableRecords.dataSource = self;
    self.tableRecords.tableFooterView = [[UIView alloc]init];
    self.navigationItem.title = @"Записи";
    NSArray *paths = [FileManager getFilePaths:[AppManager standartRecordFolder]];
    self.recordsNames = [self filter:paths nameOrPath:NO];
    self.recordsPaths = [self filter:paths nameOrPath:YES];
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
    return cell;
}
- (void) goToViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioPlayer *audioPlayer = [storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
    [self.navigationController pushViewController:audioPlayer animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
