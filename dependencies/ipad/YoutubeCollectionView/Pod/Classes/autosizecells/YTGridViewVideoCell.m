//
//  YTGridViewVideoCell.m
//  IOSTemplate
//
//  Created by djzhang on 11/10/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <google-api-services-youtube/YoutubeConstants.h>
#import "YTGridViewVideoCell.h"
#import "UIView+WhenTappedBlocks.h"
#import "YoutubeParser.h"
#import "MxTabBarManager.h"


@interface YTGridViewVideoCell ()
@property(nonatomic, strong) YTYouTubeVideoCache * video;
@end


@implementation YTGridViewVideoCell

- (id)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];

   if (self) {
      // Initialization code
      NSArray * arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"YTGridViewVideoCell" owner:self options:nil];

      if ([arrayOfViews count] < 1) {
         return nil;
      }

      if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
         return nil;
      }

      self = [arrayOfViews objectAtIndex:0];

      [self setupStyle];
   }

   return self;
}


- (void)bind:(MABYT3_Video *)video placeholderImage:(UIImage *)placeholder cellSize:(CGSize)cellSize nodeConstructionQueue:(NSOperationQueue *)nodeConstructionQueue {
   self.video = video;

   NSString * videoThumbnailsUrl = video.snippet.thumbnails.medium.url;
   NSString * videoTitleValue = video.snippet.title;
   NSString * channelTitleValue = video.snippet.channelTitle;

//   NSLog(@" %@", videoThumbnailsUrl);

   // Confirm that the result represents a detailVideo. Otherwise, the
   // item will not contain a detailVideo ID.
   // 1
   ASImageNode * imageNode = [self getThumbnailsImageNode:video
                                         placeholderImage:placeholder
                                       videoThumbnailsUrl:videoThumbnailsUrl];
   imageNode.borderColor = [[UIColor whiteColor] CGColor];
   imageNode.borderWidth = 2;

   // configure the button
   imageNode.userInteractionEnabled = YES; // opt into touch handling
   [imageNode addTarget:self
                 action:@selector(tapDetected)
       forControlEvents:ASControlNodeEventTouchUpInside];

   [self.videoThumbnailsContainer addSubview:imageNode.view];

   // 2
   [self.videoTitle setText:videoTitleValue];
   // 3
   [self.videoRatingLabel setText:[NSString stringWithFormat:@"%@", video.statistics.likeCount]];
   [self.videoViewCountLabel setText:[NSString stringWithFormat:@"%@", video.statistics.viewCount]];

   // 4
   [self.videoChannelTitleLabel setText:channelTitleValue];

   // 5
   NSUInteger text = video.contentDetails.duration;
   NSString * string = [YoutubeParser timeFormatConvertToSecondsWithInteger:video.contentDetails.duration];

}


//- (ASImageNode *)getThumbnailsImageNode:(MABYT3_Video *)detailVideo placeholderImage:(UIImage *)image videoThumbnailsUrl:(NSString *)videoThumbnailsUrl {
//   ASNetworkImageNode * _imageNode = [[ASNetworkImageNode alloc] initWithCache:nil
//                                                                    downloader:[[ASBasicImageDownloader alloc] init]];
//   _imageNode.backgroundColor = [UIColor purpleColor];
//   _imageNode.URL = [NSURL URLWithString:videoThumbnailsUrl];
//   _imageNode.borderColor = [[UIColor whiteColor] CGColor];
//   _imageNode.borderWidth = 8;
//
//   return _imageNode;
//}


- (ASImageNode *)getThumbnailsImageNode:(YTYouTubeVideoCache *)video placeholderImage:(UIImage *)image videoThumbnailsUrl:(NSString *)videoThumbnailsUrl {
   ASImageNode * imageNode = [[ASImageNode alloc] init];
   imageNode.backgroundColor = [UIColor lightGrayColor];
   imageNode.frame = self.videoThumbnailsContainer.bounds;
   imageNode.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

//   if (detailVideo.hasImage) {
//      imageNode.image = detailVideo.image;
//   } else {
//      void (^downloadCompletion)(UIImage *) = ^(UIImage * image) {
//          detailVideo.hasImage = YES;
//          detailVideo.image = image;
//          imageNode.image = detailVideo.image;
//      };
//      [YTCacheImplement CacheWithImageView:imageNode
//                                          key:detailVideo.identifier
//                                      withUrl:videoThumbnailsUrl
//                              withPlaceholder:image
//                                   completion:downloadCompletion
//      ];
//   }

   return imageNode;
}


- (void)setupStyle {
   // 1
   self.videoTitle.font = [UIFont systemFontOfSize:14.0];
   self.videoTitle.textColor = [UIColor blackColor];

   // 2
   self.videoRatingLabel.font = [UIFont systemFontOfSize:12.0];
   self.videoRatingLabel.textColor = [UIColor darkGrayColor];

   self.videoViewCountLabel.font = [UIFont systemFontOfSize:12.0];
   self.videoViewCountLabel.textColor = [UIColor darkGrayColor];


}


- (void)tapDetected {
   NSLog(@"single Tap on imageview");

   [[MxTabBarManager sharedTabBarManager] pushWithVideo:self.video];

//   [self.delegate gridViewCellTap:self.detailVideo];// TODO [test] djzhang gridViewCellTap
}


@end
