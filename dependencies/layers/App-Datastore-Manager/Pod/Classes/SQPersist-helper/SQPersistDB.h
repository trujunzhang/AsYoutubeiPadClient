//
// Created by djzhang on 2/17/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SQPersistDB : NSObject


+ (void)setupSqliteDB;

+ (void)saveVideo:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString duration:(NSString *)duration;


+ (NSMutableArray *)fetchAllVideos;

+ (void)removeAllVideos:(NSMutableArray *)array;
@end