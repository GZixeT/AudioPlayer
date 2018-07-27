//
//  VCFileManager.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 19/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#define CELL_ID @"STCell_ID"
#define NUMBER_OF_SECTIONS 1

#import "AppManager.h"
#import "AudioManager.h"
#import "VCSongs.h"
#import "VCAudioPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "STCell.h"

@interface VCSongs () <UITableViewDelegate, UITableViewDataSource, STCellDelegate>
@property NSArray *songs;
@end

@implementation VCSongs

- (void)viewDidLoad {
    [super viewDidLoad];
    MPMediaQuery *mediaQuery = [MPMediaQuery songsQuery];
    self.navigationItem.title = @"Список песен";
    self.songs = mediaQuery.items;
    self.tableSongs.dataSource = self;
    self.tableSongs.delegate = self;
    self.tableSongs.tableFooterView = [[UIView alloc]init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    // Do any additional setup after loading the view.
}
- (void) goToViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioPlayer *audioPlayer = [storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
    [self.navigationController pushViewController:audioPlayer animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableSongs reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    MPMediaItem *item = self.songs[indexPath.row];
    cell.delegate = self;
    cell.lbSongsName.text = item.title;
    cell.lbArtistName.text = item.artist;
    cell.pathOrURL = item.assetURL;
    cell.artwork = [item.artwork imageWithSize:item.artwork.imageCropRect.size];
    self.tableSongs.rowHeight = 70;
    return cell;
}
@end
