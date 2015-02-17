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

- (void)setForSavingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString duration:(NSString *)duration {
    self.videoID = videoID;
    self.videoTitle = [self encodeString:videoTitle];
    self.channelTitle = [self encodeString:channelTitle];
    self.min_string = [self encodeString:min_string];
    self.likeCount = likeCount;
    self.dislikeCount = dislikeCount;
    self.viewCount = viewCount;
    self.descriptionString = [self encodeString:descriptionString];
    self.duration = duration;
    self.time = [self currentTime];
}

- (instancetype)initForSavingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString duration:(NSString *)duration {
    self = [super init];
    if(self) {
        self.videoID = videoID;
        self.videoTitle = [self encodeString:videoTitle];
        self.channelTitle = [self encodeString:channelTitle];
        self.min_string = [self encodeString:min_string];
        self.likeCount = likeCount;
        self.dislikeCount = dislikeCount;
        self.viewCount = viewCount;
        self.descriptionString = [self encodeString:descriptionString];
        self.duration = duration;
        self.time = [self currentTime];
    }

    return self;
}

- (instancetype)initForReadingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string duration:(NSString *)duration likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString time:(NSString *)time {
    self = [super init];
    if(self) {
        self.videoID = videoID;
        self.videoTitle = [self decodeString:videoTitle];
        self.channelTitle = [self decodeString:channelTitle];
        self.min_string = [self decodeString:min_string];
        self.duration = duration;
        self.likeCount = likeCount;
        self.dislikeCount = dislikeCount;
        self.viewCount = viewCount;
        self.descriptionString = [self decodeString:descriptionString];
        self.time = time;
    }

    return self;
}

+ (NSMutableDictionary *)getCreateDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"text" forKey:@"videoID"];
    [dictionary setObject:@"text" forKey:@"videoTitle"];
    [dictionary setObject:@"text" forKey:@"channelTitle"];
    [dictionary setObject:@"text" forKey:@"min_string"];
    [dictionary setObject:@"text" forKey:@"duration"];

    [dictionary setObject:@"text" forKey:@"likeCount"];
    [dictionary setObject:@"text" forKey:@"dislikeCount"];
    [dictionary setObject:@"text" forKey:@"viewCount"];
    [dictionary setObject:@"text" forKey:@"descriptionString"];
    [dictionary setObject:@"text" forKey:@"time"];


    return dictionary;
}

- (NSMutableDictionary *)getInsertDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.videoID forKey:@"videoID"];
    [dictionary setObject:self.videoTitle forKey:@"videoTitle"];
    [dictionary setObject:self.channelTitle forKey:@"channelTitle"];
    [dictionary setObject:self.min_string forKey:@"min_string"];
    [dictionary setObject:self.duration forKey:@"duration"];

    [dictionary setObject:self.likeCount forKey:@"likeCount"];
    [dictionary setObject:self.dislikeCount forKey:@"dislikeCount"];
    [dictionary setObject:self.viewCount forKey:@"viewCount"];
    [dictionary setObject:self.descriptionString forKey:@"descriptionString"];
    [dictionary setObject:self.time forKey:@"time"];


    return dictionary;
}

+ (NSArray *)sqlStringSerializationForCreate {
    NSMutableDictionary *dictionary = [self getCreateDictionary];

    NSMutableArray *allValues = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary.allKeys) {
        [allValues addObject:[NSString stringWithFormat:@" %@ %@ ", key, [dictionary objectForKey:key]]];
    }
    NSString *tableValueString = [allValues componentsJoinedByString:@","];

    return tableValueString;
}

- (NSArray *)sqlStringSerializationForInsert {
    NSMutableDictionary *dictionary = [self getInsertDictionary];

    NSArray *allKeys = dictionary.allKeys;
    NSString *tableFieldString = [allKeys componentsJoinedByString:@","];


    NSMutableArray *allValues = [[NSMutableArray alloc] init];
    for (NSString *value in dictionary.allValues) {
        [allValues addObject:[NSString stringWithFormat:@"\"%@\"", value]];
    }
    NSString *tableValueString = [allValues componentsJoinedByString:@","];


    return @[tableFieldString, tableValueString];
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

- (NSString *)currentTime {
    NSDateFormatter *formatter;
    NSString *dateString;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];

    dateString = [formatter stringFromDate:[NSDate date]];

    return dateString;
}


@end
