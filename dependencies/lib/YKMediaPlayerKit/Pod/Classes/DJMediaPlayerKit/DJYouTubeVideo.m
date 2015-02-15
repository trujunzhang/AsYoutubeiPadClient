//
// Created by djzhang on 2/15/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "DJYouTubeVideo.h"


@implementation DJYouTubeVideo {

}

- (instancetype)initWithVideoId:(NSString *)videoId {
    self = [super init];
    if(self) {
        self.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", videoId]];
    }
    return self;
}


- (void)playInView:(UIView *)pView withQualityOptions:(YKQualityOptions)quality {
    if(!self.player) [self movieViewController:quality];

    self.player.moviePlayer.view.translatesAutoresizingMaskIntoConstraints = NO;
    [pView addSubview:self.player.moviePlayer.view];
    [self fitView:self.player.moviePlayer.view intoView:pView];

    [self.player.moviePlayer play];
}


- (void)fitView:(UIView *)toPresentView intoView:(UIView *)containerView {
    NSDictionary *viewsDictionary = @{@"detailView_Container" : toPresentView};

    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[detailView_Container]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictionary]];

    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailView_Container]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictionary]];
}


@end