//
//  YTAsyncGridViewVideoCollectionViewCell.h
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "AsyncDisplayKit.h"
#import "YoutubeConstants.h"


@interface YTAsyncGridViewVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic) CGSize const featureImageSizeOptional;
@property (nonatomic, strong) CALayer *placeholderLayer;
@property (nonatomic, strong) CALayer *contentLayer;
@property (nonatomic, strong) ASDisplayNode *containerNode;
@property (nonatomic, strong) NSOperation *nodeConstructionOperation;

- (void)bind:(YTYouTubeVideoCache *)cache placeholderImage:(UIImage *)placeholder cellSize:(CGSize)cellSize nodeConstructionQueue:(NSOperationQueue *)nodeConstructionQueue;
@end
