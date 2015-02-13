#import <Foundation/Foundation.h>

@interface ABVideo : NSObject

@property (strong, nonatomic) NSString *videoID;

@property (strong, nonatomic) NSString *videoTitle;
@property (strong, nonatomic) NSString *channelTitle;

@property (strong, nonatomic) NSString *min_string;

@property (strong, nonatomic) NSString *likeCount;
@property (strong, nonatomic) NSString *dislikeCount;
@property (strong, nonatomic) NSString *viewCount;

@property (strong, nonatomic) NSString *descriptionString;

- (instancetype)initForSavingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString;


- (instancetype)initForReadingWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle min_string:(NSString *)min_string likeCount:(NSString *)likeCount dislikeCount:(NSString *)dislikeCount viewCount:(NSString *)viewCount descriptionString:(NSString *)descriptionString;
@end
