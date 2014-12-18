//
//  YoutubeCollectionViewBase.h
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYoutubeRequestInfo.h"

@class GYoutubeRequestInfo;
@class YTGridViewVideoCell;

#define LAYOUT_MINIMUMCOLUMNSPACING 10;
#define DEFAULT_LOADING_MORE_HEIGHT 140;
#define FOOTER_IDENTIFIER @"WaterfallFooter"

#define  CollectionVideoReuseCell YTAsyncGridViewVideoCollectionViewCell
//#define  CollectionVideoReuseCell YTGridViewVideoCell




@protocol YoutubeCollectionNextPageDelegate<NSObject>

@optional
- (void)executeRefreshTask;
- (void)executeNextPageTask;
@end


@interface YoutubeCollectionViewBase : UIViewController

@property(nonatomic, strong) NSArray * numbersPerLineArray;


- (GYoutubeRequestInfo *)getYoutubeRequestInfo;
- (void)setUICollectionView:(UICollectionView *)collectionView;
- (void)showTopRefreshing;
- (void)hideTopRefreshing;
- (UICollectionViewCell *)collectionCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)search:(NSString *)text withItemType:(YTSegmentItemType)itemType;
- (void)searchByPageToken;
- (void)cleanupForTableView;
- (void)cleanup;
- (void)fetchActivityListByType:(YTSegmentItemType)type withChannelId:(NSString *)channelId;
- (void)fetchActivityListByPageToken;

- (void)fetchVideoListFromChannelWithChannelId:(NSString *)channelId;
- (void)fetchVideoListFromChannelByPageToken;
- (void)fetchPlayListFromChannelWithChannelId:(NSString *)channelId;
- (void)fetchPlayListFromChannelByPageToken;
- (void)fetchPlayListByType:(YTPlaylistItemsType)playlistItemsType;
- (void)fetchPlayListByPageToken;
- (void)fetchSuggestionListByVideoId:(NSString *)videoId;
- (void)fetchSuggestionListByPageToken;

- (int)getCurrentColumnCount:(UIInterfaceOrientation)orientation;

- (CGSize)cellSize;
- (UIEdgeInsets)getUIEdgeInsetsForLayout;

@property(nonatomic, strong) NSOperationQueue * nodeConstructionQueue;
@property(nonatomic, strong) id<YoutubeCollectionNextPageDelegate> nextPageDelegate;

- (instancetype)initWithNextPageDelegate:(id<YoutubeCollectionNextPageDelegate>)nextPageDelegate withTitle:(NSString *)title;

- (void)reloadTableView:(NSArray *)array withLastRowCount:(NSUInteger)lastRowCount;
- (void)tableWillAppear;

@end
