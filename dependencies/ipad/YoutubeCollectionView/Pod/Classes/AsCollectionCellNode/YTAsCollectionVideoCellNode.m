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
    YTAsFirstVideoRowNode *_asFirstVideoRowNode;
    YTAsSecondVideoRowNode *_asSecondVideoRowNode;
    YTAsThirdVideoRowNode *_asThirdVideoRowNode;

    CGFloat _cellWidth;
    CGFloat _firstCellHeight;

}
@end


@implementation YTAsCollectionVideoCellNode {

}


- (instancetype)initWithCellNodeOfSize:(CGSize)cellSize withVideo:(id)nodeVideo {
    if(!(self = [super init]))
        return nil;

    _cellWidth = cellSize.width;

    _firstCellHeight = 360 * (cellSize.width) / 480;

    CGFloat cellY = 0;
    CGRect cgRect = CGRectMake(0, cellY, _cellWidth, _firstCellHeight);
    _asFirstVideoRowNode = [[YTAsFirstVideoRowNode alloc] initWithCellNodeRect:cgRect withVideo:nodeVideo];

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _cellWidth, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondVideoRowNode = [[YTAsSecondVideoRowNode alloc] initWithCellNodeRect:cgRect withVideo:nodeVideo];

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _cellWidth, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdVideoRowNode = [[YTAsThirdVideoRowNode alloc] initWithCellNodeRect:cgRect withVideo:nodeVideo];


    [self addSubnode:_asFirstVideoRowNode];
    [self addSubnode:_asSecondVideoRowNode];
    [self addSubnode:_asThirdVideoRowNode];


    return self;
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return CGSizeMake(_cellWidth, [YTAsRowNode collectionCellHeight:_firstCellHeight]);
}


- (void)layout {
    CGFloat cellY = 0;
    CGRect cgRect = CGRectMake(0, cellY, _cellWidth, _firstCellHeight);
    _asFirstVideoRowNode.frame = cgRect;

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _cellWidth, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondVideoRowNode.frame = cgRect;

    cellY = cgRect.origin.y + cgRect.size.height;
    cgRect = CGRectMake(0, cellY, _cellWidth, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdVideoRowNode.frame = cgRect;
}


@end