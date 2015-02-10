#import <Foundation/Foundation.h>
#import "ABVideo.h"

typedef void(^VideoResultsBlock)(NSArray *videos);


@interface MobileDB : NSObject


#pragma mark - Base

+ (MobileDB *)dbInstance;

- (id)initWithFile:(NSString *)filePathName;

- (void)close;


#pragma mark - Reports

- (void)saveVideo:(ABVideo *)abVideo;

- (void)allVideos:(VideoResultsBlock)videosBlock;

#pragma mark - Preferences

- (NSString *)preferenceForKey:(NSString *)key;

- (void)setPreference:(NSString *)value forKey:(NSString *)key;

#pragma mark - Utilities

- (NSString *)uniqueID;

@end


