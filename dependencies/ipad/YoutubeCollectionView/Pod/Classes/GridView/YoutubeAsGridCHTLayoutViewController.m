//
//  YoutubeAsGridCHTLayoutViewController.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "YoutubeAsGridCHTLayoutViewController.h"

#import "YTAsCollectionVideoCellNode.h"

#import "YoutubeFooterView.h"

#define ASGRIDROWCELL YTAsCollectionVideoCellNode


@interface YoutubeAsGridCHTLayoutViewController ()<ASCollectionViewDataSource, ASCollectionViewDelegate>
@property (strong, nonatomic) ASCollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end


@implementation YoutubeAsGridCHTLayoutViewController

- (void)viewDidLoad {
    [self makeCollectionView];
    [self setUICollectionView:self.collectionView];

    [self.collectionView reloadData];
    [super viewDidLoad];
}


#pragma mark -
#pragma mark reload table


- (void)reloadTableView:(NSArray *)array withLastRowCount:(NSUInteger)lastRowCount {
    int newCount = array.count;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0;i < newCount;i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(lastRowCount + i) inSection:0];
        [indexPaths addObject:indexPath];
    }
}


- (void)tableWillAppear { // used
    [self showTopRefreshing];
    [self.nextPageDelegate executeNextPageTask];
}


#pragma mark -
#pragma mark


- (void)makeCollectionView {
    if(!self.collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];

        self.layout.sectionInset = [self getUIEdgeInsetsForLayout];
//        self.layout.footerHeight = DEFAULT_LOADING_MORE_HEIGHT;
//        self.layout.minimumColumnSpacing = LAYOUT_MINIMUMCOLUMNSPACING;
        self.layout.minimumInteritemSpacing = 10;
//        self.layout.delegate = self;

        self.collectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        self.collectionView.asyncDataSource = self;
        self.collectionView.asyncDelegate = self;

//        [self.collectionView registerClass:[YoutubeFooterView class]
//                forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
//                       withReuseIdentifier:FOOTER_IDENTIFIER];

    }
}


#pragma mark - Life Cycle


- (void)dealloc {
    self.collectionView.asyncDataSource = nil;
    self.collectionView.asyncDelegate = nil;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect rect = self.view.bounds;
    self.collectionView.frame = rect;

//    [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
}


- (void)updateLayout:(UIInterfaceOrientation)orientation {
//    self.layout.columnCount = [self getCurrentColumnCount:orientation];
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self getYoutubeRequestInfo].videoList.count;
}


- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node = [self getCellNodeAtIndexPath:indexPath];

    return node;
}


- (ASCellNode *)getCellNodeAtIndexPath:(NSIndexPath *)indexPath {

    ASCellNode *node;

    YTSegmentItemType itemType = [self getYoutubeRequestInfo].itemType;

    if(itemType == YTSegmentItemVideo) {
        YTYouTubeVideoCache *video = [[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row];

        ASGRIDROWCELL *videoCellNode = [[ASGRIDROWCELL alloc] initWithCellNodeOfSize:[self cellSize] withVideo:video];

        node = videoCellNode;
    }

    return node;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;

//    if([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
//        YoutubeFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                           withReuseIdentifier:FOOTER_IDENTIFIER
//                                                                                  forIndexPath:indexPath];
//        footerView.hidden = NO;
//
//        if([self getYoutubeRequestInfo].hasLoadingMore) {
//            [footerView startAnimation];
//            if(self.nextPageDelegate)
//                [self.nextPageDelegate executeNextPageTask];
//        } else {
//            footerView.hidden = YES;
//            [footerView stopAnimation];
//        }
//
//        reusableView = footerView;
//    }

    return reusableView;
}


#pragma mark -
#pragma mark  UICollectionViewDelegate


#pragma mark - CHTCollectionViewDelegateWaterfallLayout


- (CGSize)collectionWaterfallView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellSize];
}


@end

