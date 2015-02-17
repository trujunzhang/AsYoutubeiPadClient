//
//  YoutubeCollectionViewBase.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//
#import "YoutubeCollectionViewBase.h"

#import "GYoutubeHelper.h"
#import "YTAsyncGridViewVideoCollectionViewCell.h"
#import "YTGridViewPlaylistCell.h"
#import "YTAsRowNode.h"
#import "ClientUIHelper.h"


@interface YoutubeCollectionViewBase () {
    GYoutubeRequestInfo *_youtubeRequestInfo;

    int collectionWidth;
}

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UICollectionView *baseCollectionView;

@end


@implementation YoutubeCollectionViewBase

- (instancetype)initWithNextPageDelegate:(id<YoutubeCollectionNextPageDelegate>)nextPageDelegate withTitle:(NSString *)title {
    self = [super init];
    if(self) {
        self.nextPageDelegate = nextPageDelegate;
        self.title = title;
    }

    return self;
}


- (GYoutubeRequestInfo *)getYoutubeRequestInfo {
    if(_youtubeRequestInfo == nil) {
        _youtubeRequestInfo = [[GYoutubeRequestInfo alloc] init];
    }
    return _youtubeRequestInfo;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.isFirstRequest = NO;

    // Do any additional setup after loading the view.
    NSAssert(self.baseCollectionView, @"not set UICollectionVier instance!");
    NSAssert(self.nextPageDelegate, @"not found YoutubeCollectionNextPageDelegate!");
    NSAssert(self.numbersPerLineArray, @"not found numbersPerLineArray!");

    [self setupRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    collectionWidth = (int)self.view.frame.size.width;

    if(self.isFirstRequest == NO) {
        self.isFirstRequest = YES;
        [self tableWillAppear];
    }
}


- (void)dealloc {
    _youtubeRequestInfo = nil;
}


- (void)setUICollectionView:(UICollectionView *)collectionView {
    self.baseCollectionView = collectionView;

    self.baseCollectionView.backgroundView = [ClientUIHelper mainUIBackgroundView:self.view.bounds];
    [self.view addSubview:self.baseCollectionView];

    self.baseCollectionView.showsVerticalScrollIndicator = NO;
    self.baseCollectionView.directionalLockEnabled = YES;
}


#pragma mark -
#pragma mark all refresh methods


- (void)setupRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor redColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlAction)
                  forControlEvents:UIControlEventValueChanged];

    [self.baseCollectionView addSubview:self.refreshControl];
}


- (void)showTopRefreshing {
    [self.refreshControl beginRefreshing];
}


- (void)hideTopRefreshing {
    [self.refreshControl endRefreshing];
}


- (void)refreshControlAction {
    // Enter your code for request you are creating here when you pull the collectionView. When the request is completed then the collectionView go to its original position.
    [self performSelector:@selector(executeRefreshPerformEvent) withObject:(self) afterDelay:(4.0)];
}


- (void)executeRefreshPerformEvent {
    [self.nextPageDelegate executeRefreshTask];//used
//   [self.nextPageDelegate executeNextPageTask];//test
//   [self.refreshControl endRefreshing];//test
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UICollectionViewCell *)collectionCellAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_identifier = [self getYoutubeRequestInfo].itemIdentify;
    YTSegmentItemType itemType = [self getYoutubeRequestInfo].itemType;

    UICollectionViewCell *viewCell = [self.baseCollectionView dequeueReusableCellWithReuseIdentifier:cell_identifier forIndexPath:indexPath];

    switch (itemType) {
        case YTSegmentItemVideo: {
            YTYouTubeVideoCache *video = [[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row];
            CollectionVideoReuseCell *gridViewVideoCell = (CollectionVideoReuseCell *)viewCell;
            [gridViewVideoCell bind:video
                   placeholderImage:nil
                           cellSize:[self cellSize]
              nodeConstructionQueue:self.nodeConstructionQueue];
        }
            break;
        case YTSegmentItemPlaylist: {
            YTYouTubePlayList *video = [[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row];
            YTGridViewPlaylistCell *gridViewVideoCell = (YTGridViewPlaylistCell *)viewCell;
            [gridViewVideoCell bind:video
                   placeholderImage:nil];
        }
            break;
    }


    return viewCell;
}


#pragma mark -
#pragma mark Search events


- (void)search:(NSString *)text withItemType:(YTSegmentItemType)itemType {
    [self cleanup];

    [[self getYoutubeRequestInfo] resetRequestInfoForSearchWithItemType:itemType withQueryTeam:text];
}


- (void)searchByPageToken {
    if([self checkRequest])
        return;


    YoutubeResponseBlock completion = ^(NSArray *array, NSObject *respObject) {
        [self updateAfterResponse:array];
    };
    ErrorResponseBlock error = ^(NSError *error) {
    };
    [[GYoutubeHelper getInstance] searchByQueryWithRequestInfo:[self getYoutubeRequestInfo]
                                             completionHandler:completion
                                                  errorHandler:error];
}


- (void)cleanup {
    [[self getYoutubeRequestInfo] resetInfo];
    [[self baseCollectionView] reloadData];
}


#pragma mark -
#pragma mark  Fetch Activity list by channelID


- (void)fetchActivityListByType:(YTSegmentItemType)itemType withChannelId:(NSString *)channelId {
//   channelId = @"UCl78QGX_hfK6zT8Mc-2w8GA";
    [self cleanup];

    [[self getYoutubeRequestInfo] resetRequestInfoForActivityListFromChannelWithChannelId:channelId];
}


- (void)fetchActivityListByPageToken {
    if([self checkRequest])
        return;

    YoutubeResponseBlock completion = ^(NSArray *array, NSObject *respObject) {
        [self updateAfterResponse:array];
    };
    ErrorResponseBlock error = ^(NSError *error) {
        NSString *debug = @"debug";
    };
    [[GYoutubeHelper getInstance] fetchActivityListWithRequestInfo:[self getYoutubeRequestInfo]
                                                 CompletionHandler:completion
                                                      errorHandler:error];
}


- (void)updateAfterResponse:(NSArray *)array {
    [self.refreshControl endRefreshing];
    [self getYoutubeRequestInfo].isLoading = NO;

    NSUInteger lastRowCount = [self getYoutubeRequestInfo].videoList.count;
    NSLog(@"lastRowCount = %u", lastRowCount);
    [[self getYoutubeRequestInfo] appendNextPageData:array];

    if(lastRowCount == 0) {
        [self.baseCollectionView reloadData];
    } else {
        [self reloadTableView:array withLastRowCount:lastRowCount];
    }
}


#pragma mark -
#pragma mark  Fetch video list by channelID


- (void)fetchVideoListFromChannelWithChannelId:(NSString *)channelId {
//   channelId = @"UCl78QGX_hfK6zT8Mc-2w8GA";

    [self cleanup];

    [[self getYoutubeRequestInfo] resetRequestInfoForVideoListFromChannelWithChannelId:channelId];
}


- (void)fetchVideoListFromChannelByPageToken {
    [self searchByPageToken];
}


#pragma mark -
#pragma mark  Fetch playLists by channelID


- (void)fetchPlayListFromChannelWithChannelId:(NSString *)channelId {
//   channelId = @"UCl78QGX_hfK6zT8Mc-2w8GA";

    [self cleanup];

    [[self getYoutubeRequestInfo] resetRequestInfoForPlayListFromChannelWithChannelId:channelId];
}


- (void)fetchPlayListFromChannelByPageToken {
    if([self checkRequest])
        return;

//   NSLog(@" *** fetchPlayListFromChannelByPageToken = %d", [[self getYoutubeRequestInfo] hasNextPage]);

    YoutubeResponseBlock completion = ^(NSArray *array, NSObject *respObject) {
        [self updateAfterResponse:array];
    };
    ErrorResponseBlock error = ^(NSError *error) {
        NSString *debug = @"debug";
    };
    [[GYoutubeHelper getInstance] fetchPlayListFromChannelWithRequestInfo:[self getYoutubeRequestInfo]
                                                        completionHandler:completion
                                                             errorHandler:error
    ];
}


- (BOOL)checkRequest {
    if([[self getYoutubeRequestInfo] isLoading]) {
        return YES;
    }

    if([[self getYoutubeRequestInfo] hasNextPage]) {
        if([[self getYoutubeRequestInfo] isLoading] == NO) {
            [self getYoutubeRequestInfo].isLoading = YES;
            return NO;
        }
    }

    return [[self getYoutubeRequestInfo] hasNextPage] == NO;
}


#pragma mark -
#pragma mark  Fetch Activity list by channelID


- (void)fetchPlayListByType:(YTPlaylistItemsType)playlistItemsType {
    [self cleanup];

//   NSLog(@" *** fetchPlayListByType = %d", [[self getYoutubeRequestInfo] hasNextPage]);
    [[self getYoutubeRequestInfo] resetRequestInfoForPlayList:playlistItemsType];
}


- (void)fetchPlayListByPageToken {
    if([self checkRequest])
        return;

//   NSLog(@" *** fetchPlayListByPageToken = %d", [[self getYoutubeRequestInfo] hasNextPage]);

    YoutubeResponseBlock completion = ^(NSArray *array, NSObject *respObject) {
        [self updateAfterResponse:array];
    };
    ErrorResponseBlock error = ^(NSError *error) {
        NSString *debug = @"debug";
    };
    [[GYoutubeHelper getInstance] fetchPlaylistItemsListWithRequestInfo:[self getYoutubeRequestInfo] completion:completion errorHandler:error];
}

#pragma mark -
#pragma mark  Fetch suggestion list by videoID


- (void)fetchSuggestionListByVideoId:(NSString *)videoId {
//   videoId = @"mOQ5DzROpuo";
    [self cleanup];

    [[self getYoutubeRequestInfo] resetRequestInfoForSuggestionList:videoId];
}


- (void)fetchSuggestionListByPageToken {
    [self searchByPageToken];
}


#pragma mark - 
#pragma mark 


- (int)getCurrentColumnCount:(UIInterfaceOrientation)orientation {
    return [(self.numbersPerLineArray[UIInterfaceOrientationIsPortrait(orientation) ? 0 : 1]) intValue];
}


- (CGSize)cellSize {
    CGSize size;

    NSString *key = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? @"vertical" : @"horizontal";

    NSString *keyWidth = [NSString stringWithFormat:@"%@_width_%d", key, collectionWidth];
    NSString *keyHeight = [NSString stringWithFormat:@"%@_height_%d", key, collectionWidth];

    NSNumber *valueWidth = [YoutubeParser queryCacheWithKey:keyWidth];
    NSNumber *valueHeight = [YoutubeParser queryCacheWithKey:keyHeight];
    if(valueWidth && valueHeight) {
        size = CGSizeMake([valueWidth floatValue], [valueHeight floatValue]);
    } else {
        size = [self makeCellSize:[UIApplication sharedApplication].statusBarOrientation withCollectionWidth:collectionWidth];
        [YoutubeParser cacheWithKey:keyWidth withValue:[NSNumber numberWithFloat:size.width]];
        [YoutubeParser cacheWithKey:keyHeight withValue:[NSNumber numberWithFloat:size.height]];
    }

    return size;
}


- (CGSize)makeCellSize:(UIInterfaceOrientation)orientation withCollectionWidth:(CGFloat)collectionWidth {
    int columnCount = [self getCurrentColumnCount:orientation];
    UIEdgeInsets uiEdgeInsets = [self getUIEdgeInsetsForLayout];

    CGFloat mini_num_column_space = LAYOUT_MINIMUMCOLUMNSPACING;

    CGFloat usableSpace =
            (collectionWidth
                    - uiEdgeInsets.left - uiEdgeInsets.right
                    - ((columnCount - 1) * mini_num_column_space)
            );

    CGFloat cellLength = usableSpace / columnCount;

    CGFloat cellHeight = [YTAsRowNode collectionCellHeight:[self getFirstCellHeight]];

    return CGSizeMake(cellLength, cellHeight);
}

- (CGFloat)getFirstCellHeight {
    return 138;
}


- (UIEdgeInsets)getUIEdgeInsetsForLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end






