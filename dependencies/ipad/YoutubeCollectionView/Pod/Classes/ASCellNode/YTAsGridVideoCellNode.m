//
//  YTAsGridVideoCellNode.m
//  IOSTemplate
//
//  Created by djzhang on 11/17/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <IOS_Collection_Code/HexColor.h>
#import "YTAsGridVideoCellNode.h"
#import "YoutubeParser.h"
#import "YTAsChannelThumbnailsImageNode.h"
#import "FrameCalculator.h"
#import "Foundation.h"
#import "AsyncDisplayKitStatic.h"
#import "UIColor+iOS8Colors.h"
#import "YTAsyncGridViewVideoNode.h"


@interface YTAsGridVideoCellNode () {
    CGSize _kittenSize;


    YTAsyncGridViewVideoNode *_asyncGridViewVideoNode;
}
@end


@implementation YTAsGridVideoCellNode


- (instancetype)initWithCellNodeOfSize:(CGSize)size withVideo:(YTYouTubeVideoCache *)video { //242,242
    if(!(self = [super init]))
        return nil;

    _kittenSize = size;
    self.video = video;

    _asyncGridViewVideoNode = [[YTAsyncGridViewVideoNode alloc] initWithCardInfo:self.video
                                                                        cellSize:_kittenSize
                                                                        isBacked:NO];

    [self addSubnode:_asyncGridViewVideoNode];

    return self;
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return _kittenSize;
}


- (void)layout {

}


@end
