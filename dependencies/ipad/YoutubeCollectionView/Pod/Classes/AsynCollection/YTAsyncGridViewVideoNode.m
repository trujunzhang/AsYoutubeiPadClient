//
//  YTAsyncGridViewVideoNode.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "ASCacheNetworkImageNode.h"

#import "FrameCalculator.h"

#import "YTAsyncGridViewVideoNode.h"
#import "AnimatedContentsDisplayLayer.h"
#import "Foundation.h"
#import "HexColor.h"
#import "UIColor+iOS8Colors.h"
#import "YoutubeParser.h"

#import "AsyncDisplayKitStatic.h"
#import "YTAsChannelThumbnailsImageNode.h"
#import "MxTabBarManager.h"


@interface YTAsyncGridViewVideoNode () {

}
@property (nonatomic) CGFloat durationLabelWidth;

@property (nonatomic, strong) ASImageNode *videoCoverThumbnailsNode;
@property (nonatomic, strong) ASTextNode *durationTextNode;

@property (nonatomic, strong) ASTextNode *videoTitleTextNode;

@property (nonatomic, strong) ASImageNode *_channelImageNode;
@property (nonatomic, strong) ASTextNode *channelTitleTextNode;

@property (nonatomic, strong) ASDisplayNode *divider;

@end


@implementation YTAsyncGridViewVideoNode

- (instancetype)initWithCardInfo:(YTYouTubeVideoCache *)cardInfo cellSize:(CGSize)cellSize isBacked:(BOOL)isBacked {
//    self = [super initWithLayerClass:[AnimatedContentsDisplayLayer class]];
//    if(self) {
//        self.nodeCellSize = cellSize;
//        self.cardInfo = cardInfo;
//
//        [self makeContainerNode];
//        [self layoutSubNodes];
//
//        [self setupAllNodesEffect];
//        [self setAllNodeBacked];
//    }

    return self;
}


- (void)setAllNodeBacked {
    self.layerBacked = true;

    // line01
    self.videoCoverThumbnailsNode.layerBacked = true;
    self.durationTextNode.layerBacked = true;

    // line02
    self.videoTitleTextNode.layerBacked = true;
    self.divider.layerBacked = true;

    // line03
    self._channelImageNode.layerBacked = true;
    self.channelTitleTextNode.layerBacked = true;
}


#pragma mark -
#pragma mark Setup sub nodes.


- (void)makeContainerNode {
    [self rowFirstForChannelClover];
    [self rowSecondForChannelTitle];
    [self rowThirdForChannelInfo];
}


- (void)setupAllNodesEffect {
    // 1.1
    self.backgroundColor = [UIColor whiteColor];

    // 1.2
    self.shadowColor = [UIColor colorWithHexString:@"B5B5B5" alpha:0.8].CGColor;
    self.shadowOffset = CGSizeMake(1, 3);
    self.shadowOpacity = 1.0;
    self.shadowRadius = 2.0;

    [self effectFirstForChannelClover];
    [self effectSecondForChannelTitle];
    [self effectThirdForChannelInfo];
}


- (void)layoutSubNodes {
    //MARK: Node Layout Section
    self.frame = [FrameCalculator frameForContainer:self.nodeCellSize];

    [self layoutFirstForChannelClover];
    [self layoutSecondForChannelTitle];
    [self layoutThirdForChannelInfo];
}


#pragma mark -
#pragma mark first row for channel clover.(Row N01)


- (void)rowFirstForChannelClover {
    // 1
    ASCacheNetworkImageNode *videoChannelThumbnailsNode =
            [ASCacheNetworkImageNode nodeWithImageUrl:[YoutubeParser getVideoSnippetThumbnails:self.cardInfo]];

    // configure the button
    videoChannelThumbnailsNode.userInteractionEnabled = YES; // opt into touch handling
    [videoChannelThumbnailsNode addTarget:self
                                   action:@selector(channelThumbnailsTapped:)
                         forControlEvents:ASControlNodeEventTouchUpInside];

    self.videoCoverThumbnailsNode = videoChannelThumbnailsNode;
    [self addSubnode:self.videoCoverThumbnailsNode];

    // 2
    NSString *durationString = [YoutubeParser getVideoDurationForVideoInfo:self.cardInfo];
    self.durationLabelWidth = [FrameCalculator calculateWidthForDurationLabel:durationString];

    ASTextNode *durationTextNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForDurationText:durationString]];
    durationTextNode.backgroundColor = [UIColor colorWithHexString:@"1F1F21" alpha:0.6];

    self.durationTextNode = durationTextNode;
    [self addSubnode:self.durationTextNode];
}


- (void)channelThumbnailsTapped:(id)buttonTapped {
    [[MxTabBarManager sharedTabBarManager] pushWithVideo:self.cardInfo];
}


- (void)layoutFirstForChannelClover {
    self.videoCoverThumbnailsNode.frame =
            [FrameCalculator frameForChannelThumbnails:self.nodeCellSize nodeFrameHeight:FIRST_ROW_HEIGHT];


    self.durationTextNode.frame =
            [FrameCalculator frameForDurationWithCloverSize:self.videoCoverThumbnailsNode.frame.size
                                          withDurationWidth:self.durationLabelWidth];
}


- (void)effectFirstForChannelClover {
    // 2
    self.videoCoverThumbnailsNode.contentMode = UIViewContentModeScaleAspectFit;

    // 2.1
    self.videoCoverThumbnailsNode.backgroundColor = [UIColor iOS8silverGradientStartColor];

    // 2.2
    self.videoCoverThumbnailsNode.borderColor = [UIColor colorWithHexString:@"DDD"].CGColor;
    self.videoCoverThumbnailsNode.borderWidth = 1;

    self.videoCoverThumbnailsNode.shadowColor = [UIColor colorWithHexString:@"B5B5B5"].CGColor;
    self.videoCoverThumbnailsNode.shadowOffset = CGSizeMake(1, 3);
    self.videoCoverThumbnailsNode.shadowRadius = 2.0;


}


#pragma mark -
#pragma mark second row for channel title.(Row N02)


- (void)rowSecondForChannelTitle {
    // 1
    ASTextNode *titleTextNode =
            [ASTextNode initWithAttributedString:[NSAttributedString attributedStringForTitleText:[YoutubeParser getVideoSnippetTitle:self.cardInfo]]];

    //MARK: Container Node Creation Section
    self.videoTitleTextNode = titleTextNode;
    [self addSubnode:self.videoTitleTextNode];

    // hairline cell separator
    self.divider = [[ASDisplayNode alloc] init];
    self.divider.backgroundColor = [UIColor colorWithHexString:@"EAEAEA" alpha:1.0];
    [self addSubnode:self.divider];
}


- (void)layoutSecondForChannelTitle {
    self.videoTitleTextNode.frame = [FrameCalculator frameForTitleText:self.bounds
                                                     featureImageFrame:self.videoCoverThumbnailsNode.frame];

    self.divider.frame = [FrameCalculator frameForDivider:self.bounds.size thirdRowHeight:THIRD_ROW_HEIGHT];
}


- (void)effectSecondForChannelTitle {
    self.videoTitleTextNode.backgroundColor = [UIColor clearColor];
}


#pragma mark -
#pragma mark second row for channel info.(Row N03)


- (void)rowThirdForChannelInfo {
    // 1
    [self showChannelThumbnail:[YoutubeParser getChannelIdByVideo:self.cardInfo]];

    // 2
    ASTextNode *channelTitleTextNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForChannelTitleText:[YoutubeParser getVideoSnippetChannelTitle:self.cardInfo]]];


    //MARK: Container Node Creation Section
    self.channelTitleTextNode = channelTitleTextNode;
    [self addSubnode:self.channelTitleTextNode];
}


- (void)showChannelThumbnail:(NSString *)channelId {
//   YTAsChannelThumbnailsImageNode * videoChannelThumbnailsNode = [YTAsChannelThumbnailsImageNode nodeWithChannelId:channelId];

//   self._channelImageNode = videoChannelThumbnailsNode;
//   [self addSubnode:self._channelImageNode];
}


- (void)layoutThirdForChannelInfo {
    self._channelImageNode.frame = [FrameCalculator frameForChannelThumbnail:self.bounds
                                                              thirdRowHeight:THIRD_ROW_HEIGHT];

    self.channelTitleTextNode.frame = [FrameCalculator frameForChannelTitleText:self.bounds
                                                                 thirdRowHeight:THIRD_ROW_HEIGHT
                                                                  leftNodeFrame:self._channelImageNode.frame];
}


- (void)effectThirdForChannelInfo {
    self.channelTitleTextNode.backgroundColor = [UIColor clearColor];
}


@end
