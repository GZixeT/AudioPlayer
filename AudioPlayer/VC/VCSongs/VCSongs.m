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
#import "AnimationManager.h"
#import "AudioPlayer.h"
#import "LandscapeManager.h"

@interface VCSongs () <UITableViewDelegate, UITableViewDataSource, STCellDelegate>
@property NSArray *songs;
@property BOOL isLockLandscape;
@end

@implementation VCSongs

- (void)viewDidLoad {
    [super viewDidLoad];
    MPMediaQuery *mediaQuery = [MPMediaQuery songsQuery];
    self.navigationItem.title = @"Список композиций";
    self.songs = mediaQuery.items;
    self.tableSongs.dataSource = self;
    self.tableSongs.delegate = self;
    self.tableSongs.tableFooterView = [[UIView alloc]init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self initViewGestures];
    // Do any additional setup after loading the view.
}
- (void) initViewGestures {
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeL];
    [self.view addGestureRecognizer:swipeR];
}
- (void) swipeLeft {
    if([AudioPlayer sharedInstance].audioPlayer)
        [self goToViewController];
    else [self.navigationController popToRootViewControllerAnimated:YES];
    [self.view.window.layer addAnimation:[AnimationManager transitionAnimationBeforViewDisappearWithType:GesturesAnimationSwipeRight] forKey:nil];
}
- (void) swipeRight {
    NSInteger last = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:last - 1] animated:YES];
}
- (void) goToViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VCAudioPlayer *audioPlayer = [storyboard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
    [AudioPlayer sharedInstance].playType = PlayTypeAll;
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
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isLockLandscape = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        if(!self.isLockLandscape)
            [LandscapeManager toLandscapeVC:self];
    }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    MPMediaItem *item = self.songs[indexPath.row];
    cell.delegate = self;
    cell.lbSongsName.text = item.title;
    cell.lbArtistName.text = item.artist;
    cell.pathOrURL = item.assetURL;
    cell.artwork = [item.artwork imageWithSize:item.artwork.imageCropRect.size];
    cell.indexPath = indexPath;
    self.tableSongs.rowHeight = 70;
    return cell;
}
@end
