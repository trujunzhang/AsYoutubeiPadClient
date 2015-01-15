//
//  YTGridVideoCellNode.h
//  IOSTemplate
//
//  Created by djzhang on 11/17/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "YoutubeConstants.h"


@interface YTGridVideoCellNode : ASCellNode

- (instancetype)initWithCellNodeOfSize:(CGSize)size withVideo:(YTYouTubeVideoCache *)video;

@property (nonatomic, strong) YTYouTubeVideoCache *video;
@property (nonatomic) CGFloat durationLabelWidth;

- (void)bind:(YTYouTubeVideoCache *)video placeholderImage:(UIImage *)placeholder;
@end
