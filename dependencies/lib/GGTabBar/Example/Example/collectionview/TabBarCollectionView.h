//
//  TabBarCollectionView.h
//  Example
//
//  Created by djzhang on 12/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface TabBarCollectionView : UIViewController

@property(nonatomic, strong) NSMutableArray * titleArray;
@property(nonatomic) CGFloat viewHeight;

- (instancetype)initWithTitleArray:(NSMutableArray *)titleArray withViewHeight:(CGFloat)viewHeight;

@end
