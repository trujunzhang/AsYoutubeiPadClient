//
//  YoutubeGridLayoutViewController.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "YoutubeGridLayoutViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "KRLCollectionViewGridLayout.h"
#import "YTGridVideoCellNode.h"


int step = 0;


@interface YoutubeGridLayoutViewController ()<ASCollectionViewDataSource, ASCollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate>
@property(strong, nonatomic) ASCollectionView * collectionView;
@end


@implementation YoutubeGridLayoutViewController

- (void)viewDidLoad {
   [self makeCollectionView];
   [self setUICollectionView:self.collectionView];

   [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
   [super viewDidAppear:animated];

   [self.nextPageDelegate executeNextPageTask]; // test

   [self reloadControlAction];
}


- (void)reloadControlAction {
   // Enter your code for request you are creating here when you pull the collectionView. When the request is completed then the collectionView go to its original position.
   [self performSelector:@selector(refreshPerformEvent) withObject:(self) afterDelay:(12.0)];
}


- (void)refreshPerformEvent {
   [self.nextPageDelegate executeNextPageTask]; // test

   step++;
   if (step < 4)
      [self reloadControlAction];
}


#pragma mark -
#pragma mark reload table


- (void)reloadTableView:(NSArray *)array withLastRowCount:(NSUInteger)lastRowCount {
   int newCount = array.count;
   NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
   for (int i = 0; i < newCount; i++) {
      NSIndexPath * indexPath = [NSIndexPath indexPathForItem:(lastRowCount + i) inSection:0];
      [indexPaths addObject:indexPath];
   }

//   [self.collectionView appendNodesWithIndexPaths:indexPaths];
}


- (void)tableWillAppear { // used

}


#pragma mark -
#pragma mark


- (void)makeCollectionView {
   if (!self.collectionView) {
      self.layout = [[KRLCollectionViewGridLayout alloc] init];
      self.layout.aspectRatio = 1;
      self.layout.interitemSpacing = 10;
      self.layout.lineSpacing = LAYOUT_MINIMUMCOLUMNSPACING;

      UIEdgeInsets uiEdgeInsets = [self getUIEdgeInsetsForLayout];
      self.layout.sectionInset = uiEdgeInsets;

      self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;

      self.collectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
      self.collectionView.asyncDataSource = self;
      self.collectionView.asyncDelegate = self;
   }
}


#pragma mark - Life Cycle


- (void)dealloc {
   self.collectionView.asyncDataSource = nil;
   self.collectionView.asyncDelegate = nil;
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];
   self.collectionView.frame = self.view.bounds;

   [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
}


- (void)updateLayout:(UIInterfaceOrientation)orientation {
   self.layout.numberOfItemsPerLine = [(self.numbersPerLineArray[UIInterfaceOrientationIsPortrait(orientation) ? 0 : 1]) intValue];
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [self getYoutubeRequestInfo].videoList.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return 1;
}


- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
   ASCellNode * node = [self getCellNodeAtIndexPath:indexPath];

   return node;
}


- (ASCellNode *)getLoadMoreNode {
   ASCellNode * node = [[ASCellNode alloc] init];

   // attribute a string
   NSDictionary * attrs = @{
    NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
    NSForegroundColorAttributeName : [UIColor redColor],
   };
   NSAttributedString * string = [[NSAttributedString alloc] initWithString:@"shuffle"
                                                                 attributes:attrs];

   // create the node
   ASTextNode * _shuffleNode = [[ASTextNode alloc] init];
   _shuffleNode.attributedString = string;

   // configure the button
   _shuffleNode.userInteractionEnabled = YES; // opt into touch handling

   // size all the things
   CGSize size = [_shuffleNode measure:CGSizeMake(self.view.bounds.size.width, 140)];
   CGPoint origin = CGPointMake(0, 0);
   _shuffleNode.frame = (CGRect) { origin, size };

   [node addSubnode:_shuffleNode];

//   [self.nextPageDelegate executeNextPageTask];

   return node;
}


- (ASCellNode *)getCellNodeAtIndexPath:(NSIndexPath *)indexPath {

   ASCellNode * node;

   YTSegmentItemType itemType = [self getYoutubeRequestInfo].itemType;

   if (itemType == YTSegmentItemVideo) {
      YTYouTubeVideoCache * video = [[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row];

      YTGridVideoCellNode * videoCellNode =
       [[YTGridVideoCellNode alloc] initWithCellNodeOfSize:[self cellSize] withVideo:video];

      node = videoCellNode;
   }

   return node;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//   NSLog(@"method:  %s", sel_getName(_cmd));
//   for (UICollectionViewCell * cell in [self.collectionView visibleCells]) {
//      NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
//      if (indexPath.section == 0) {
//         NSLog(@"%s", sel_getName(_cmd));
//         [self.nextPageDelegate executeNextPageTask];
//         return;
//      }
//   }
}


@end

