//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsFirstVideoRowNode.h"
#import "Foundation.h"
#import "AsyncDisplayKitStatic.h"
#import "MxTabBarManager.h"


@interface YTAsFirstVideoRowNode () {
    ASImageNode *_videoCoverThumbnailsNode;
    ASTextNode *_durationTextNode;
}

@property (nonatomic) CGFloat durationLabelWidth;

@end


@implementation YTAsFirstVideoRowNode {

}


- (void)makeRowNode {
    _videoCoverThumbnailsNode = [ASCacheNetworkImageNode nodeWithImageUrl:[YoutubeParser getVideoSnippetThumbnails:self.nodeInfo]];
    _videoCoverThumbnailsNode.contentMode = UIViewContentModeScaleToFill;

    [self addSubnode:_videoCoverThumbnailsNode];

    [self setNodeTappedEvent];

    // 2
    NSString *durationString = [YoutubeParser getVideoDurationForVideoInfo:self.nodeInfo];
    self.durationLabelWidth = [FrameCalculator calculateWidthForDurationLabel:durationString];

    _durationTextNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForDurationText:durationString]];
    _durationTextNode.backgroundColor = [UIColor colorWithHexString:@"1F1F21" alpha:0.6];

    [self addSubnode:_durationTextNode];
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return self.cellRect.size;
}


- (void)layout {
    _videoCoverThumbnailsNode.frame = self.cellRect;

    _durationTextNode.frame =
            [FrameCalculator frameForDurationWithCloverSize:self.cellRect.size
                                          withDurationWidth:self.durationLabelWidth];
}

#pragma mark -
#pragma mark node tapped event


- (void)setNodeTappedEvent {
    // configure the button
    _videoCoverThumbnailsNode.userInteractionEnabled = YES; // opt into touch handling
    [_videoCoverThumbnailsNode addTarget:self
                                  action:@selector(buttonTapped:)
                        forControlEvents:ASControlNodeEventTouchUpInside];
}


- (void)buttonTapped:(id)buttonTapped {
    [[MxTabBarManager sharedTabBarManager] pushWithVideo:self.nodeInfo];
}

@end