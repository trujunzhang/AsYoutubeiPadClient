//
//  HistoryViewController.m
//  mxAsTubeiPad
//
//  Created by djzhang on 12/8/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "HistoryViewController.h"
#import "MobileDB.h"
#import "YoutubeParser.h"

@interface HistoryViewController ()<YoutubeCollectionNextPageDelegate>
@property (nonatomic, strong) NSMutableArray *videosArray;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    self.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];
    self.nextPageDelegate = self;

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self executeRefreshTask];
    [super viewWillAppear:animated];
}


- (void)readAllVideosFromDB {
    self.videosArray = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view.
    VideoResultsBlock videosBlock = ^(NSArray *videos) {
        for (ABVideo *abVideo in videos) {
            [self.videosArray addObject:[YoutubeParser convertAbVideoToYoutubeVideo:abVideo]];
        }
        [self updateAfterResponse:self.videosArray];

        NSString *debug = @"debug";
    };
    [[MobileDB dbInstance] allVideos:videosBlock];
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
