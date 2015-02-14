//
//  EasySpendLogDB.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MobileDB.h"
#import "ABSQLiteDB.h"


static MobileDB *_dbInstance;


@interface MobileDB ()

@end


@implementation MobileDB {
    id<ABDatabase> db;
}


#pragma mark - Base


- (id)init {
    return [self initWithFile:NULL];
}


- (id)initWithFile:(NSString *)filePathName {
    if(!(self = [super init])) return nil;

    _dbInstance = self;

    BOOL myPathIsDir;
    BOOL fileExists = [[NSFileManager defaultManager]
            fileExistsAtPath:filePathName
                 isDirectory:&myPathIsDir];

    // backupDbPath allows for a pre-made database to be in the app. Good for testing
    NSString *backupDbPath = [[NSBundle mainBundle]
            pathForResource:@"YoutubeVideoDB"
                     ofType:@"db"];
    BOOL copiedBackupDb = NO;
    if(backupDbPath != nil) {
        copiedBackupDb = [[NSFileManager defaultManager]
                copyItemAtPath:backupDbPath
                        toPath:filePathName
                         error:nil];
    }

    // open SQLite db file
    db = [[ABSQLiteDB alloc] init];

    if(![db connect:filePathName]) {
        return nil;
    }

    if(!fileExists) {
        if(!backupDbPath || !copiedBackupDb)
            [self makeDB];
    }

    [self checkSchema]; // always check schema because updates are done here

    return self;
}


+ (MobileDB *)dbInstance {
    if(!_dbInstance) {
        NSString *dbFilePath;
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentFolderPath = searchPaths[0];
        dbFilePath = [documentFolderPath stringByAppendingPathComponent:@"YoutubeVideoDB.db"];

        MobileDB *mobileDB = [[MobileDB alloc] initWithFile:dbFilePath];
        if(!mobileDB) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Error"
                                                            message:@"Unable to open database."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Darn"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }

    return _dbInstance;
}


- (void)close {
    [db close];
}


#pragma mark - Videos


- (void)saveVideo:(ABVideo *)abVideo {
    NSString *sql = [NSString stringWithFormat:@"select videoID from Videos where videoID = %i", abVideo.videoID];
    BOOL exists = NO;

    id<ABRecordset> results = [db sqlSelect:sql];
    if(![results eof])
        exists = YES;

    if(exists) {

    } else {
        // add the abVideo
        NSArray *sqlStringSerializationForInsert = [abVideo sqlStringSerializationForInsert];
        sql = [NSString stringWithFormat:@"insert into OnlineVideoType(%@) values(,%@)", sqlStringSerializationForInsert[0], sqlStringSerializationForInsert[1]];
        [db sqlExecute:sql];
    }

}


- (void)allVideos:(VideoResultsBlock)videosBlock {
    NSMutableArray *videos = [[NSMutableArray alloc] init];
    NSString *sql = @"select * from Videos order by time ASC";
    id<ABRecordset> results = [db sqlSelect:sql];
    while (![results eof]) {
        ABVideo *abVideo = [[ABVideo alloc] initForReadingWithVideoID:[[results fieldWithName:@"videoID"] stringValue]
                                                           videoTitle:[[results fieldWithName:@"videoTitle"] stringValue]
                                                         channelTitle:[[results fieldWithName:@"channelTitle"] stringValue]
                                                           min_string:[[results fieldWithName:@"min_string"] stringValue]
                                                             duration:[[results fieldWithName:@"duration"] stringValue]
                                                            likeCount:[[results fieldWithName:@"likeCount"] stringValue]
                                                         dislikeCount:[[results fieldWithName:@"dislikeCount"] stringValue]
                                                            viewCount:[[results fieldWithName:@"viewCount"] stringValue]
                                                    descriptionString:[[results fieldWithName:@"descriptionString"] stringValue]
                                                                 time:[[results fieldWithName:@"time"] stringValue]

        ];


        [videos addObject:abVideo];

        [results moveNext];
    }

    videosBlock(videos);
}


#pragma mark - Preferences


- (NSString *)preferenceForKey:(NSString *)key {
    NSString *preferenceValue = @"";

    NSString *sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

    id<ABRecordset> results;
    results = [db sqlSelect:sql];

    if(![results eof]) {
        preferenceValue = [[results fieldWithName:@"value"] stringValue];
    }

    return preferenceValue;
}


- (void)setPreference:(NSString *)value forKey:(NSString *)key {
    if(!value) {
        return;
    }

    NSString *sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

    id<ABRecordset> results;
    results = [db sqlSelect:sql];
    if([results eof]) {
        sql = [NSString stringWithFormat:@"insert into preferences(property,value) values('%@','%@');",
                                         key,
                                         [self escapeText:value]];
    }
    else {
        sql = [NSString stringWithFormat:@"update preferences set value = '%@' where property = '%@';",
                                         [self escapeText:value],
                                         key];
    }

    [db sqlExecute:sql];
}


#pragma mark - Utilities


- (void)makeDB {

    // Videos
    NSString *command = [NSString stringWithFormat:@"create table Videos(%@, primary key(videoID));", [ABVideo sqlStringSerializationForCreate]];
    [db sqlExecute:command];

    // Internal
    [db sqlExecute:@"create table Preferences(property text, value text, primary key(property));"];

    [self setPreference:@"1" forKey:@"SchemaVersion"];
}


- (void)checkSchema {
    NSString *schemaVersion = [self preferenceForKey:@"SchemaVersion"];

    if([schemaVersion isEqualToString:@"1"]) {
        [db sqlExecute:@"create index idx_preferences_property on Preferences(property);"];
        [db sqlExecute:@"create index idx_videos_videoid on Videos(videoID);"];
        [db sqlExecute:@"create index idx_videoattributes_videoid on VideoAttributes(videoID);"];

        schemaVersion = @"2";
    }

    [db sqlExecute:@"ANALYZE"];

    [self setPreference:schemaVersion forKey:@"SchemaVersion"];
}


- (NSString *)uniqueID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);

    return uuidString;
}


- (NSString *)escapeText:(NSString *)text {
    NSString *newValue = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    return newValue;
}

@end
