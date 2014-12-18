//
//  YoutubeGridCHTLayoutViewController.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "YoutubeGridCHTLayoutViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "YoutubeFooterView.h"
#import "YTAsyncGridViewVideoCollectionViewCell.h"
#import "YTGridViewVideoCell.h"
#import "MxTabBarManager.h"


@interface YoutubeGridCHTLayoutViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>
@property(strong, nonatomic) UICollectionView * collectionView;
@property(nonatomic, strong) CHTCollectionViewWaterfallLayout * layout;
@end


//YoutubeGridFlowLayoutViewController
@implementation YoutubeGridCHTLayoutViewController

- (void)viewDidLoad {
   [self makeCollectionView];
   [self setUICollectionView:self.collectionView];

   [super viewDidLoad];
}


- (void)makeCollectionView {
   if (!self.collectionView) {
      self.layout = [[CHTCollectionViewWaterfallLayout alloc] init];

      UIEdgeInsets uiEdgeInsets = [self getUIEdgeInsetsForLayout];
      self.layout.sectionInset = uiEdgeInsets;
      self.layout.footerHeight = DEFAULT_LOADING_MORE_HEIGHT;
      self.layout.minimumColumnSpacing = LAYOUT_MINIMUMCOLUMNSPACING;
      self.layout.minimumInteritemSpacing = 10;
      self.layout.delegate = self;


      self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
      self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      self.collectionView.dataSource = self;
      self.collectionView.delegate = self;

      [self.collectionView registerClass:[CollectionVideoReuseCell class]
              forCellWithReuseIdentifier:[GYoutubeRequestInfo getIdentifyByItemType:YTSegmentItemVideo]];

      [self.collectionView registerClass:[YoutubeFooterView class]
              forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                     withReuseIdentifier:FOOTER_IDENTIFIER];
   }
}


#pragma mark -
#pragma mark reload table


- (void)reloadTableView:(NSArray *)array withLastRowCount:(NSUInteger)count {
   [self.collectionView reloadData];
}


- (void)tableWillAppear {// used
}


#pragma mark - Life Cycle


- (void)dealloc {
   self.collectionView.delegate = nil;
   self.collectionView.dataSource = nil;
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

   _collectionView.frame = self.view.bounds;
   [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
}


- (void)updateLayout:(UIInterfaceOrientation)orientation {
   self.layout.columnCount = [self getCurrentColumnCount:orientation];
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [self getYoutubeRequestInfo].videoList.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   return [self collectionCellAtIndexPath:indexPath];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
   UICollectionReusableView * reusableView = nil;

   if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
      YoutubeFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                                 forIndexPath:indexPath];
      footerView.hidden = NO;

      if ([self getYoutubeRequestInfo].hasLoadingMore) {
         [footerView startAnimation];
         [self.nextPageDelegate executeNextPageTask];
      } else {
         footerView.hidden = YES;
         [footerView stopAnimation];
      }

      reusableView = footerView;
   }

   return reusableView;
}


#pragma mark -
#pragma mark  UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   [[MxTabBarManager sharedTabBarManager] pushWithVideo:[[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row]];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout


- (CGSize)collectionWaterfallView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return [self cellSize];
}


@end

