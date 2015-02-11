//
//  MFIReport.m
//  MobileApp
//
//  Created by Aaron Bratcher on 12/13/2012.
//  Copyright (c) 2012 Market Force. All rights reserved.
//

#import "ABVideo.h"


@interface ABVideo ()<NSCoding>

@end

@implementation ABVideo

- (instancetype)initWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle {
    self = [super init];
    if(self) {
        self.videoID = videoID;
        self.videoTitle = videoTitle;
        self.channelTitle = channelTitle;
    }

    return self;
}


@end
