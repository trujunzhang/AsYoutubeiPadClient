//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsRowNode.h"


@implementation YTAsRowNode {

}

- (instancetype)initWithCellNodeRect:(CGRect)cellRect withVideo:(id)nodeInfo { //242,242
    if(!(self = [super init]))
        return nil;

    self.cellRect = cellRect;
    self.nodeInfo = nodeInfo;

    [self makeRowNode];

    return self;
}


#pragma mark -
#pragma mark

+ (CGFloat)getFirstCellHeight {
    return 138;
}

+ (void)setCellFirstHeight:(CGFloat)height {

}


+ (CGFloat)collectionCellHeight {
    return [YTAsRowNode getFirstCellHeight] + COLLECTION_CELL_SECOND_HEIGHT + COLLECTION_CELL_THIRD_HEIGHT;
}


@end