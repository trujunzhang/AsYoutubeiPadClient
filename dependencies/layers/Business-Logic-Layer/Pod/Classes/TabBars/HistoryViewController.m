//
//  HistoryViewController.m
//  mxAsTubeiPad
//
//  Created by djzhang on 12/8/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "HistoryViewController.h"
#import "MobileDB.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    VideoResultsBlock videosBlock = ^(NSArray *videos) {
        NSString *debug = @"debug";
    };
    [[MobileDB dbInstance] allVideos:videosBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
