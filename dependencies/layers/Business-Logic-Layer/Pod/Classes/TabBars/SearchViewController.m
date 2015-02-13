//
//  SearchViewController.m
//  TubeIPadApp
//
//  Created by djzhang on 10/23/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//



#import "SearchViewController.h"

#import "YTVideoDetailViewController.h"
#import "YoutubePopUpTableViewController.h"
#import "GYoutubeHelper.h"

#import "MxTabBarManager.h"


@interface SearchViewController ()<UISearchBarDelegate, YoutubeCollectionNextPageDelegate> {
    YTCollectionViewController *_collectionViewController;
//    YTCollectionViewController *_lastCollectionViewController;
}
@property (strong, nonatomic) IBOutlet UIView *presentation;

@property (strong, nonatomic) UISegmentedControl *segment_title;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *sarchBarItem;
@end


@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor clearColor];

    [self setupNavigationRightItem];
    [self setupNavigationTitle];

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (void)setupNavigationRightItem {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 220, 19)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.userInteractionEnabled = YES;
    self.searchBar.placeholder = @"Search";

    self.searchBar.text = @"opium flower"; // test
    [self segmentAction:nil]; // test

    self.searchBar.delegate = self;

    self.sarchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = self.sarchBarItem;
}


- (void)setupNavigationTitle {
    self.segment_title = [[UISegmentedControl alloc] initWithItems:[GYoutubeRequestInfo getSegmentTitlesArray]];
    self.segment_title.selectedSegmentIndex = 0;
    self.segment_title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segment_title.frame = CGRectMake(0, 0, 300, 30);
    [self.segment_title addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segment_title.tintColor = [UIColor redColor];
    self.navigationItem.titleView = self.segment_title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UISearchBarDelegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self segmentAction:nil];

    [self.searchBar resignFirstResponder];

    [self hidePopup];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self showPopupDialog:self.sarchBarItem];

    if([self.searchBar.text isEqualToString:@""]) {
        [self cleanUpContent];
        return;
    }

    YoutubeResponseBlock completion = ^(NSArray *array, NSObject *respObject) {
        [self reloadContent:array];
    };
    ErrorResponseBlock error = ^(NSError *error) {
        NSString *debug = @"debug";
    };
    [[GYoutubeHelper getInstance] autoCompleteSuggestions:self.searchBar.text
                                        CompletionHandler:completion
                                             errorHandler:error];
}


#pragma mark -
#pragma mark -  UISegmentedControl event

- (YTCollectionViewController *)makeNewCollectionViewForSearchBar {
    YTCollectionViewController *controller = [[YTCollectionViewController alloc] initWithNextPageDelegate:self
                                                                                                withTitle:nil];
    controller.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];

    controller.view.frame = self.view.bounds;// used
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    return controller;
}


- (void)fitView:(UIView *)toPresentView intoView:(UIView *)containerView {
    NSDictionary *viewsDictioanry = @{@"presented_view" : toPresentView};

    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[presented_view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictioanry]];

    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[presented_view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictioanry]];
}

- (void)replaceViewController:(YoutubeAsGridCHTLayoutViewController *)viewController withSearchText:(NSString *)text withItemType:(YTSegmentItemType)itemType {

    UIView *presentedView = [self.presentation.subviews firstObject];
    if(presentedView) {
        [presentedView removeFromSuperview];
    }

    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.presentation addSubview:viewController.view];
    [self fitView:viewController.view intoView:self.presentation];


    [self addChildViewController:viewController];

    _collectionViewController = viewController;
    [viewController search:text withItemType:itemType];
}


- (void)segmentAction:(id)sender {
    if(self.searchBar.text.length == 0)
        return;

    [self replaceViewController:[self makeNewCollectionViewForSearchBar]
                 withSearchText:self.searchBar.text
                   withItemType:[GYoutubeRequestInfo getItemTypeByIndex:self.segment_title.selectedSegmentIndex]];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
    [self segmentAction:nil];
}


- (void)executeNextPageTask {
    [_collectionViewController searchByPageToken];
}


#pragma mark -
#pragma mark YoutubePopUpTableViewDelegate


- (void)didSelectRowWithValue:(NSString *)value {
    self.searchBar.text = value;
    [self searchBarSearchButtonClicked:nil];
}


@end