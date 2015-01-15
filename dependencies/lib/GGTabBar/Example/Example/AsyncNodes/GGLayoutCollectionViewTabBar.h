//
//  GGLayoutCollectionViewTabBar.h
//  Example
//
//  Created by djzhang on 12/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGTabBar.h"

@class TabBarCollectionView;


@interface GGLayoutCollectionViewTabBar : GGTabBar

@property (nonatomic, strong) TabBarCollectionView *collectionView;
@end
