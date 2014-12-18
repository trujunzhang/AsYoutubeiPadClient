//
//  YTGridVideoCellNode.m
//  IOSTemplate
//
//  Created by djzhang on 11/17/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <IOS_Collection_Code/HexColor.h>
#import "YTGridVideoCellNode.h"
#import "YoutubeParser.h"
#import "YTAsChannelThumbnailsImageNode.h"
#import "FrameCalculator.h"
#import "Foundation.h"
#import "AsyncDisplayKitStatic.h"

#import "UIColor+iOS8Colors.h"
#import "MxTabBarManager.h"


@interface YTGridVideoCellNode () {
   CGSize _kittenSize;

   // line01
   ASImageNode * _videoCoverThumbnailsNode;
   ASTextNode * _durationTextNode;

   // line02
   ASDisplayNode * _infoContainerNode;
   ASTextNode * _videoTitleNode;

   // line03

   // line04

   ASImageNode * _channelImageNode;
   ASTextNode * _channelTitleNode;
}
@end


@implementation YTGridVideoCellNode


- (instancetype)initWithCellNodeOfSize:(CGSize)size withVideo:(YTYouTubeVideoCache *)video { //242,242
   if (!(self = [super init]))
      return nil;

   _kittenSize = size;
   self.video = video;

   [self makeUI];
   [self effectFirstForChannelClover];
   [self setNodeTappedEvent];

   return self;
}


- (void)makeUI {
   // 1
   _videoCoverThumbnailsNode = [ASCacheNetworkImageNode nodeWithImageUrl:[YoutubeParser getVideoSnippetThumbnails:self.video]];
   [self addSubnode:_videoCoverThumbnailsNode];

   // 2
   NSString * durationString = [YoutubeParser getVideoDurationForVideoInfo:self.video];
   self.durationLabelWidth = [FrameCalculator calculateWidthForDurationLabel:durationString];

   _durationTextNode = [ASTextNode initWithAttributedString:
    [NSAttributedString attributedStringForDurationText:durationString]];
   _durationTextNode.backgroundColor = [UIColor colorWithHexString:@"1F1F21" alpha:0.6];

   [self addSubnode:_durationTextNode];

   // 2
   _infoContainerNode = [[ASDisplayNode alloc] init];
   _infoContainerNode.backgroundColor = [UIColor clearColor];
   [self addSubnode:_infoContainerNode];

   // 2.1
//   _channelImageNode = [YTAsChannelThumbnailsImageNode nodeWithChannelId:[YoutubeParser getChannelIdByVideo:self.video]];
//   [_infoContainerNode addSubnode:_channelImageNode];

   // 2.2
   _videoTitleNode = [ASTextNode initWithAttributedString:
    [[NSAttributedString alloc] initWithString:[YoutubeParser getVideoSnippetTitle:self.video]
                                    attributes:[self textStyleForVideoTitle]]];
   [_infoContainerNode addSubnode:_videoTitleNode];

   // 2.3
   _channelTitleNode = [ASTextNode initWithAttributedString:
    [[NSAttributedString alloc] initWithString:[YoutubeParser getVideoSnippetChannelTitle:self.video]
                                    attributes:[self textStyleForChannelTitle]]];
   [_infoContainerNode addSubnode:_channelTitleNode];
}


- (void)effectFirstForChannelClover {
   // 2
   _videoCoverThumbnailsNode.contentMode = UIViewContentModeScaleAspectFit;

   // 2.1
   _videoCoverThumbnailsNode.backgroundColor = [UIColor iOS8silverGradientStartColor];

   // 2.2
   _videoCoverThumbnailsNode.borderColor = [UIColor colorWithHexString:@"DDD"].CGColor;
   _videoCoverThumbnailsNode.borderWidth = 1;

   _videoCoverThumbnailsNode.shadowColor = [UIColor colorWithHexString:@"B5B5B5"].CGColor;
   _videoCoverThumbnailsNode.shadowOffset = CGSizeMake(1, 3);
   _videoCoverThumbnailsNode.shadowRadius = 2.0;


}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return _kittenSize;
}


- (NSDictionary *)textStyleForVideoTitle {
   NSString * fontName = @"HelveticaNeue";
//   fontName = @"ChalkboardSE-Regular";
   UIFont * font = [UIFont fontWithName:fontName size:14.0f];

   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   style.paragraphSpacing = 0.5 * font.lineHeight;
   style.hyphenationFactor = 1.0;
//   style.lineBreakMode = NSLineBreakByTruncatingTail;


   return @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
}


- (NSDictionary *)textStyleForChannelTitle {
   UIFont * font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];

   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   style.paragraphSpacing = 0.5 * font.lineHeight;
   style.hyphenationFactor = 1.0;
   style.lineBreakMode = NSLineBreakByTruncatingTail;

   return @{
    NSFontAttributeName : font,
    NSParagraphStyleAttributeName : style,
    NSForegroundColorAttributeName : [UIColor lightGrayColor]
   };
}


- (void)layout {
   // 1
   _videoCoverThumbnailsNode.frame = [FrameCalculator frameForChannelThumbnails:_kittenSize
                                                                nodeFrameHeight:FIRST_ROW_HEIGHT];

   _durationTextNode.frame =
    [FrameCalculator frameForDurationWithCloverSize:_videoCoverThumbnailsNode.frame.size
                                  withDurationWidth:self.durationLabelWidth];

   // 2
   CGFloat infoContainerHeight = _kittenSize.height - FIRST_ROW_HEIGHT;
   _infoContainerNode.frame = CGRectMake(0, FIRST_ROW_HEIGHT + 8, _kittenSize.width, infoContainerHeight - 4);

   // 2.1
   CGFloat titleLeftX = 28;
   _channelImageNode.frame = CGRectMake(0, 3, titleLeftX - 8, titleLeftX - 4);
   CGFloat titleWidth = _kittenSize.width - titleLeftX;
   _videoTitleNode.frame = CGRectMake(titleLeftX, 0, titleWidth, 36);
   _channelTitleNode.frame = CGRectMake(titleLeftX, 36, titleWidth, 32);
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

   [[MxTabBarManager sharedTabBarManager] pushWithVideo:self.video];

//      [self.delegate gridViewCellTap:self.detailVideo];// TODO [test] djzhang gridViewCellTap
}

@end
