//
// Created by djzhang on 2/17/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "SQPersistDB.h"
#import "SQPDatabase.h"
#import "ABVideo.h"


@implementation SQPersistDB {

}


+ (void)setupSqliteDB {
    [SQPDatabase sharedInstance].logRequests = YES;

    // Log all properties scanned :
    [SQPDatabase sharedInstance].logPropertyScan = YES;

    // Create Database :
    [[SQPDatabase sharedInstance] setupDatabaseWithName:@"YoutubeVideoDB.db"];

    // Check if table missing a property. If yes add automaticatly the associated column into the table :
    [SQPDatabase sharedInstance].addMissingColumns = YES;

    NSLog(@"DB path: %@ ", [[SQPDatabase sharedInstance] getDdPath]);
}

#pragma mark -
#pragma mark

+ (void)saveVideo:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString duration:(NSString *)duration {
    [[SQPDatabase sharedInstance] beginTransaction];

    // Create Table at the first init (if tbale ne exists) :
    ABVideo *abVideo = [ABVideo SQPCreateEntity];

    [abVideo
            setForSavingWithVideoID:videoID
                         videoTitle:videoTitle
                       channelTitle:channelTitle
                         min_string:min_string
                          likeCount:likeCount
                       dislikeCount:dislikeCount
                          viewCount:viewCount
                  descriptionString:descriptionString
                           duration:duration
    ];


    [[SQPDatabase sharedInstance] commitTransaction];
}

- (void)allVideos {

}

@end