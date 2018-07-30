//
//  VCLandscape.m
//  AudioPlayer
//
//  Created by Георгий Зубков on 30/07/2018.
//  Copyright © 2018 Георгий Зубков. All rights reserved.
//
#define CELL_ID @"CVSCell_ID"

#import "LandscapeManager.h"
#import "VCLandscape.h"
#import "CVSCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AudioPlayer.h"
#import "AudioManager.h"

@interface VCLandscape () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cvSongs;
@property NSArray *songs;
@property float cellSize;
@end

@implementation VCLandscape

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Список композиций";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:self action:@selector(playingButton)];
    self.cvSongs.delegate = self;
    self.cvSongs.dataSource = self;
    self.cellSize = self.cvSongs.frame.size.height/1.5;
    self.songs = [MPMediaQuery songsQuery].items;
    if([AudioPlayer sharedInstance].audioPlayer.isPlaying)
        self.navigationItem.rightBarButtonItem.title = @"Stop";
    [AudioManager setSessionCategoryForMultiRouteWithError:nil];
}
- (void) playingButton {
    if([AudioPlayer sharedInstance].audioPlayer.isPlaying){
        self.navigationItem.rightBarButtonItem.title = @"Play";
        [[AudioPlayer sharedInstance].audioPlayer stop];
    }else {
        self.navigationItem.rightBarButtonItem.title = @"Stop";
        [[AudioPlayer sharedInstance].audioPlayer play];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        [LandscapeManager toLandscapeVC:self];
    }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
    }];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [LandscapeManager toLandscapeVC:self];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *path = [NSIndexPath indexPathForItem:[AudioPlayer sharedInstance].playlistPosition inSection:0];
    [self.cvSongs scrollToItemAtIndexPath:path atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    float top = (self.cvSongs.frame.size.height - self.cellSize)/2;
    float left = (self.cvSongs.frame.size.width - self.cellSize)/2;
    UIEdgeInsets edge = UIEdgeInsetsMake(top, left, top, left);
    return edge;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (self.cvSongs.frame.size.width - self.cellSize)/2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.cellSize, self.cellSize);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.songs.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CVSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    MPMediaItem *item = self.songs[indexPath.item];
    cell.layer.borderWidth = 2.f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.lbSong.text = [NSString stringWithFormat:@"%@ - %@",item.artist ? item.artist:@"Неизвестный исполнитель", item.title];
    if(item.artwork) {
        [cell.bImage setBackgroundImage:[item.artwork imageWithSize:cell.frame.size] forState:(UIControlStateNormal)];
    } else {
        UIImage *noImage = [UIImage imageNamed:@"musical-note"];
        [cell.bImage setBackgroundImage:noImage forState:(UIControlStateNormal)];
    }
    cell.layer.cornerRadius = self.cellSize/2;
    cell.lbSong.layer.cornerRadius = cell.lbSong.frame.size.width/2;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MPMediaItem *item = self.songs[indexPath.item];
    NSError *error = nil;
    [AudioPlayer sharedInstance].audioPlayer = [AudioManager createAudioPlayerWithURL:item.assetURL error:&error];
    if(!error) {
        self.navigationItem.rightBarButtonItem.title = @"Stop";
        [AudioPlayer sharedInstance].artwork = [item.artwork imageWithSize:item.artwork.imageCropRect.size];
        [AudioPlayer sharedInstance].title = item.title;
        [AudioPlayer sharedInstance].artist = item.artist;
        [AudioPlayer sharedInstance].playlistPosition = indexPath.item;
        [AudioPlayer sharedInstance].playType = PlayTypeAll;
        [[AudioPlayer sharedInstance].audioPlayer play];
    }
}
@end
