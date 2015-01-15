//
//  TarBarItemNode.h
//  Example
//
//  Created by djzhang on 12/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ASControlNode+Subclasses.h"
#import "ASDisplayNode+Subclasses.h"


@interface TarBarItemNode : ASCellNode

@property (nonatomic) CGSize cellSize;

- (id)initWithCellSize:(CGSize)cellSize withTitle:(id)title isSelected:(BOOL)isSelected;

- (void)layoutByCellSize:(CGSize)cgSize;

- (void)setNodeSelected;

- (void)resetNodeSelected;
@end
