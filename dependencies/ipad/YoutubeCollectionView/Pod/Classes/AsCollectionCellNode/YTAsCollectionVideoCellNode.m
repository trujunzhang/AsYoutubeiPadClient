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
}
@end


@implementation YTAsCollectionVideoCellNode {

}


- (instancetype)initWithCellNodeOfSize:(CGSize)cellSize withVideo:(id)nodeVideo {
    if(!(self = [super init]))
        return nil;

    _kittenSize = cellSize;

    CGRect cellNodeRect = CGRectMake(0, 0, _kittenSize.width, [YTAsRowNode getFirstCellHeight]);
    _asFirstVideoRowNode = [[YTAsFirstVideoRowNode alloc] initWithCellNodeRect:cellNodeRect withVideo:nodeVideo];


    cellNodeRect = CGRectMake(0, [YTAsRowNode getFirstCellHeight], _kittenSize.width, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondVideoRowNode = [[YTAsSecondVideoRowNode alloc] initWithCellNodeRect:cellNodeRect withVideo:nodeVideo];


    cellNodeRect = CGRectMake(0, [YTAsRowNode getFirstCellHeight] + COLLECTION_CELL_SECOND_HEIGHT, _kittenSize.width, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdVideoRowNode = [[YTAsThirdVideoRowNode alloc] initWithCellNodeRect:cellNodeRect withVideo:nodeVideo];


    [self addSubnode:_asFirstVideoRowNode];
    [self addSubnode:_asSecondVideoRowNode];
    [self addSubnode:_asThirdVideoRowNode];


    return self;
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return _kittenSize;
}


- (void)layout {
    CGRect cellNodeRect = CGRectMake(0, 0, _kittenSize.width, [YTAsRowNode getFirstCellHeight]);
    _asFirstVideoRowNode.frame = cellNodeRect;

    cellNodeRect = CGRectMake(0, [YTAsRowNode getFirstCellHeight], _kittenSize.width, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondVideoRowNode.frame = cellNodeRect;

    cellNodeRect = CGRectMake(0, [YTAsRowNode getFirstCellHeight] + COLLECTION_CELL_SECOND_HEIGHT, _kittenSize.width, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdVideoRowNode.frame = cellNodeRect;
}


@end