//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsCollectionVideoCellNode.h"
#import "YoutubeConstants.h"
#import "YTAsFirstVideoRowNode.h"
#import "YTAsSecondVideoRowNode.h"
#import "YTAsThirdVideoRowNode.h"


@interface YTAsCollectionVideoCellNode () {
    CGSize _kittenSize;

    YTAsFirstVideoRowNode *_asFirstVideoRowNode;
    YTAsSecondVideoRowNode *_asSecondVideoRowNode;
    YTAsThirdVideoRowNode *_asThirdVideoRowNode;

    CGFloat _firstCellHeight;
}
@end


@implementation YTAsCollectionVideoCellNode {

}


- (instancetype)initWithCellNodeOfSize:(CGSize)cellSize firstCellHeight:(CGFloat)firstCellHeight withVideo:(id)nodeVideo {
    if(!(self = [super init]))
        return nil;

    _kittenSize = cellSize;
    _firstCellHeight = firstCellHeight;

    CGFloat cellY = 0;
    CGRect cgRect = CGRectMake(0, cellY, _kittenSize.width, _firstCellHeight);
    _asFirstVideoRowNode = [[YTAsFirstVideoRowNode alloc] initWithCellNodeRect:cgRect withVideo:nodeVideo];

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _kittenSize.width, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondVideoRowNode = [[YTAsSecondVideoRowNode alloc] initWithCellNodeRect:cgRect withVideo:nodeVideo];

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _kittenSize.width, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdVideoRowNode = [[YTAsThirdVideoRowNode alloc] initWithCellNodeRect:cgRect withVideo:nodeVideo];


    [self addSubnode:_asFirstVideoRowNode];
    [self addSubnode:_asSecondVideoRowNode];
    [self addSubnode:_asThirdVideoRowNode];


    return self;
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return _kittenSize;
}


- (void)layout {
    CGFloat cellY = 0;
    CGRect cgRect = CGRectMake(0, cellY, _kittenSize.width, _firstCellHeight);
    _asFirstVideoRowNode.frame = cgRect;

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _kittenSize.width, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondVideoRowNode.frame = cgRect;

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _kittenSize.width, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdVideoRowNode.frame = cgRect;
}


@end