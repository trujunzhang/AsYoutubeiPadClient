#import <Foundation/Foundation.h>

@interface ABVideo : NSObject

@property (strong, nonatomic) NSString *videoID;

@property (strong, nonatomic) NSString *videoTitle;
@property (strong, nonatomic) NSString *channelTitle;

- (instancetype)initWithVideoID:(NSString *)videoID videoTitle:(NSString *)videoTitle channelTitle:(NSString *)channelTitle;


@end