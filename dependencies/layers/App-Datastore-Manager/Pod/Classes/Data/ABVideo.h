#import <Foundation/Foundation.h>
#import "SQPObject.h"

@interface ABVideo : SQPObject

@property (strong, nonatomic) NSString *videoID;

@property (strong, nonatomic) NSString *videoTitle;
@property (strong, nonatomic) NSString *channelTitle;

@property (strong, nonatomic) NSString *min_string;
@property (strong, nonatomic) NSString *duration;


@property (strong, nonatomic) NSString *likeCount;
@property (strong, nonatomic) NSString *dislikeCount;
@property (strong, nonatomic) NSString *viewCount;

@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic) NSString *time;

- (void)setForSavingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString duration:(NSString *)duration;

- (instancetype)initForSavingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString duration:(NSString *)duration;


- (instancetype)initForReadingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string duration:(NSString *)duration likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString time:(NSString *)time;


+ (NSArray *)sqlStringSerializationForCreate;


- (NSArray *)sqlStringSerializationForInsert;


@end
