//
//  HistoryViewController.m
//  mxAsTubeiPad
//
//  Created by djzhang on 12/8/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "HistoryViewController.h"
#import "YoutubeParser.h"
#import "SQPersistDB.h"
#import "ABVideo.h"

@interface HistoryViewController ()<YoutubeCollectionNextPageDelegate>
@property (nonatomic, strong) NSMutableArray *videosArray;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    self.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];
    self.nextPageDelegate = self;

    [self setupNavigation];

    [super viewDidLoad];
}

- (void)setupNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"remove all"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(removeAllBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Edit"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(editBarButtonItemAction:)];

}

#pragma mark -
#pragma mark - Provided acction methods


- (void)removeAllBarButtonItemAction:(id)sender {

}

- (void)editBarButtonItemAction:(id)sender {

}

- (void)viewWillAppear:(BOOL)animated {
    self.isFirstRequest = NO;
    [self executeRefreshTask];
    [super viewWillAppear:animated];
}


- (void)readAllVideosFromDB {
    self.videosArray = [[NSMutableArray alloc] init];
    NSArray *videos = [SQPersistDB FetchAllVideos];

    for (ABVideo *abVideo in videos) {
        [self.videosArray addObject:[YoutubeParser convertAbVideoToYoutubeVideo:abVideo]];
    }
    [self updateAfterResponse:self.videosArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate

- (void)executeRefreshTask {
    [self cleanup];
}

- (void)executeNextPageTask {
    [self readAllVideosFromDB];
}


@end
