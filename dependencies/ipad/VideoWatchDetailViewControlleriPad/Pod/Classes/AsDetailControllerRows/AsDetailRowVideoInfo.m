//
// Created by djzhang on 12/13/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "AsDetailRowVideoInfo.h"

#import "YoutubeParser.h"
#import "Foundation.h"
#import "AsyncDisplayKitStatic.h"
#import "FrameCalculator.h"
#import "YoutubeConstants.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>

static CGFloat DetailRowVideoInfoHeight = 80.0f;

static CGFloat DetailRowVideoTitleHeight = 30.0f;


@implementation AsDetailRowVideoInfo {
    ASTextNode *_videoTitleNode;
    ASTextNode *_likeCountNode;
    ASTextNode *_viewCountNode;

    ASDisplayNode *_divider;

}

- (instancetype)initWithVideo:(YTYouTubeVideoCache *)videoCache withTableWidth:(CGFloat)tableViewWidth {
    if(!(self = [super init]))
        return nil;

    // create a text node
    _videoTitleNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForDetailRowChannelTitle:[YoutubeParser getVideoSnippetTitle:videoCache]
                                                                fontSize:16.0f]];

    [self addSubnode:_videoTitleNode];

    _likeCountNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForDetailRowVideoLikeCount:[YoutubeParser getVideoStatisticsLikeCount:videoCache]
                                                                  fontSize:12.0f]];

    [self addSubnode:_likeCountNode];

    _viewCountNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForDetailRowVideoViewCount:[YoutubeParser getVideoStatisticsViewCount:videoCache]
                                                                  fontSize:12.0f]];

    [self addSubnode:_viewCountNode];


    return self;
}


- (void)didLoad {
    // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
    self.layer.as_allowsHighlightDrawing = YES;

    [super didLoad];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    // called on a background thread.  custom nodes must call -measure: on their subnodes in -calculateSizeThatFits:
//   CGSize measuredSize = [_videoTitleNode measure:CGSizeMake(constrainedSize.width - 2 * kTextPaddingHorizontal, constrainedSize.height - 2 * kTextPaddingHorizontal)];

    return CGSizeMake(constrainedSize.width, DetailRowVideoInfoHeight);
}


- (void)layout {
    // called on the main thread.  we'll use the stashed size from above, instead of blocking on text sizing

    _videoTitleNode.frame = [FrameCalculator frameForDetailRowVideoInfoTitle:self.calculatedSize
                                                             withTitleHeight:DetailRowVideoTitleHeight
                                                              withFontHeight:20];

    _likeCountNode.frame = [FrameCalculator frameForDetailRowVideoInfoLikeCount:_videoTitleNode.frame];

    _viewCountNode.frame = [FrameCalculator frameForDetailRowVideoInfoViewCount:_videoTitleNode.frame
                                                               withContainWidth:self.calculatedSize.width];

}

@end