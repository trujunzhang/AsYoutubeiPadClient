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

- (instancetype)initForSavingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString duration:(NSString *)duration {
    self = [super init];
    if(self) {
        self.videoID = videoID;
        self.videoTitle = [self encodeString:videoTitle];
        self.channelTitle = [self encodeString:channelTitle];
        self.min_string = min_string;
        self.likeCount = likeCount;
        self.dislikeCount = dislikeCount;
        self.viewCount = viewCount;
        self.descriptionString = [self encodeString:descriptionString];
        self.duration = [self encodeString:duration];
        self.time = [self currentTime];
    }

    return self;
}

- (NSString *)currentTime {
    NSDateFormatter *formatter;
    NSString *dateString;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];

    dateString = [formatter stringFromDate:[NSDate date]];

    return dateString;
}

- (instancetype)initForReadingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString {
    self = [super init];
    if(self) {
        self.videoID = videoID;
        self.videoTitle = [self decodeString:videoTitle];
        self.channelTitle = [self decodeString:channelTitle];
        self.min_string = min_string;
        self.likeCount = likeCount;
        self.dislikeCount = dislikeCount;
        self.viewCount = viewCount;
        self.descriptionString = [self decodeString:descriptionString];
    }

    return self;
}


- (NSString *)encodeString:(NSString *)plainString {
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

- (NSString *)decodeString:(NSString *)base64String {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}


@end
