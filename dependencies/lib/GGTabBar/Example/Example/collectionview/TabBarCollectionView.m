//
//  TabBarCollectionView.m
//  Example
//
//  Created by djzhang on 12/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "TabBarCollectionView.h"
#import "TarBarItemNode.h"
#import "GGTabBar.h"
#import "KRLCollectionViewGridLayout.h"


@interface TabBarCollectionView ()<ASCollectionViewDataSource, ASCollectionViewDelegate> {
   ASCollectionView * _collectionView;
   NSInteger _selectedIndex;
   NSInteger _lastSelectedIndex;
}

@property(nonatomic, strong) KRLCollectionViewGridLayout * layout;
@end


@implementation TabBarCollectionView

- (instancetype)initWithTitleArray:(NSMutableArray *)titleArray withViewHeight:(CGFloat)viewHeight {
   self = [self init];
   if (self) {
      self.titleArray = titleArray;
      self.viewHeight = viewHeight;
      _selectedIndex = 0;
      _lastSelectedIndex = _selectedIndex;
   }

   return self;
}


- (instancetype)init {
   self = [super init];
   if (self) {
      self.layout = [[KRLCollectionViewGridLayout alloc] init];
      self.layout.numberOfItemsPerLine = 3;
      self.layout.aspectRatio = 1;
      self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
      self.layout.interitemSpacing = 0;
      self.layout.lineSpacing = 0;
      self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;

      _collectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
      _collectionView.asyncDataSource = self;
      _collectionView.asyncDelegate = self;
      _collectionView.backgroundColor = [UIColor whiteColor];

      _collectionView.scrollEnabled = NO;
   }

   return self;
}


- (void)viewDidLoad {
   [super viewDidLoad];

   [self.view addSubview:_collectionView];
}


- (void)viewWillLayoutSubviews {
   _collectionView.frame = self.view.bounds;
   _collectionView.center = self.view.center;
}


- (BOOL)prefersStatusBarHidden {
   return YES;
}


#pragma mark -
#pragma mark ASCollectionView data source.


- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
   NSInteger integer = indexPath.row;

   BOOL isSelected = integer == _selectedIndex;
   TarBarItemNode * node = [[TarBarItemNode alloc]
    initWithCellSize:CGSizeMake([self getTabBarItemWidth:self.titleArray.count], self.viewHeight)
           withTitle:self.titleArray[integer]
          isSelected:isSelected];


   return node;
}


- (CGFloat)getTabBarItemWidth:(NSUInteger)buttonCount {
   CGFloat totalWidth = (self.view.frame.size.width - tabBarPadding * 2);
   CGFloat allSeperatorWidth = seperatorWidth * 3;

   CGFloat tabBarItemWidth = (totalWidth - allSeperatorWidth) / buttonCount;
   return tabBarItemWidth;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.titleArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   _selectedIndex = indexPath.row;
   [_collectionView reloadData];
}

@end
