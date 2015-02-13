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

- (instancetype)initWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString {
    self = [super init];
    if(self) {
        self.videoID = videoID;
        self.videoTitle = videoTitle;
        self.channelTitle = channelTitle;
        self.min_string = min_string;
        self.likeCount = likeCount;
        self.dislikeCount = dislikeCount;
        self.viewCount = viewCount;
        self.descriptionString = descriptionString;
    }

    return self;
}


@end
