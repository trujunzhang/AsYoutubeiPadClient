//
// Created by djzhang on 2/15/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKYouTubeVideo.h"


@interface DJYouTubeVideo : YKYouTubeVideo
- (id)initWithVideoId:(NSString *)id;

- (void)playInView:(UIView *)pView withQualityOptions:(YKQualityOptions)quality;
@end