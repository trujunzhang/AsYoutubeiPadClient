//
//  SubscriptionsViewController.m
//  TubeIPadApp
//
//  Created by djzhang on 10/23/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "SubscriptionsViewController.h"

#import "YTVideoDetailViewController.h"
#import "LeftRevealHelper.h"
#import "YoutubeChannelPageViewController.h"

#import "MxTabBarManager.h"
#import "LeftMenuViewBase.h"


@interface SubscriptionsViewController ()<YoutubeCollectionNextPageDelegate, LeftMenuViewBaseDelegate> {
    YTCollectionViewController *_gridViewController;
    YTPlaylistItemsType _playlistItemsType;
}

@end


@implementation SubscriptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [[MxTabBarManager sharedTabBarManager] setLeftMenuControllerDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark LeftMenuViewBaseDelegate


- (void)startToggleLeftMenuWithTitle:(NSString *)title withType:(YTPlaylistItemsType)playlistItemsType {
    // 1
    YTCollectionViewController *gridViewController = [[YTCollectionViewController alloc] initWithNextPageDelegate:self withTitle:title];
    gridViewController.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];

    // 2
    gridViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mt_side_tab_button"]
                                                                                           style:UIBarButtonItemStyleBordered
                                                                                          target:self
                                                                                          action:@selector(leftBarButtonItemAction:)];

    // 3
    [[MxTabBarManager sharedTabBarManager] pushAndResetControllers:@[gridViewController]];

    // 4
    _playlistItemsType = playlistItemsType;
    _gridViewController = gridViewController;
    [_gridViewController fetchPlayListByType:playlistItemsType];
}


- (void)endToggleLeftMenuEventForChannelPageWithChannelId:(NSString *)channelId withTitle:(NSString *)title {
    // 1
    YoutubeChannelPageViewController *controller = [[YoutubeChannelPageViewController alloc] initWithChannelId:channelId
                                                                                                     withTitle:title];

    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mt_side_tab_button"]
                                                                                   style:UIBarButtonItemStyleBordered
                                                                                  target:self
                                                                                  action:@selector(leftBarButtonItemAction:)];

    [[MxTabBarManager sharedTabBarManager] pushAndResetControllers:@[controller]];
}


#pragma mark -
#pragma mark - Provided acction methods


- (void)leftBarButtonItemAction:(id)sender {
    [[LeftRevealHelper sharedLeftRevealHelper] toggleReveal];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
    [_gridViewController fetchPlayListByType:_playlistItemsType];
}


- (void)executeNextPageTask {
    [_gridViewController fetchPlayListByPageToken];
}


@end
