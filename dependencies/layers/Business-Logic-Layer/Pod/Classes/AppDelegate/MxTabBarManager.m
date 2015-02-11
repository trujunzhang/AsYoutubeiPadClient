#import <google-api-services-youtube/GYoutubeHelper.h>
#import "MxTabBarManager.h"
#import "YTVideoDetailViewController.h"
#import "LeftMenuViewController.h"
#import "LeftRevealHelper.h"
#import "ClientUIHelper.h"
#import "CollectionConstant.h"
#import "MobileDB.h"
#import "YoutubeParser.h"


@interface MxTabBarManager ()<GYoutubeHelperDelegate> {
    UITabBarController *_tabBarController;
    YTLeftMenuViewController *_leftViewController; // left
}


@end


@implementation MxTabBarManager

+ (MxTabBarManager *)sharedTabBarManager {
    static MxTabBarManager *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[MxTabBarManager alloc] init];
        [GYoutubeHelper getInstance].delegate = cache;
    });

    return cache;
}


- (void)registerTabBarController:(UITabBarController *)tabBarController withLeftViewController:(id)leftViewController {
    _tabBarController = tabBarController;
    _leftViewController = leftViewController;
}

#pragma mark -
#pragma mark video local store.

- (void)saveVideo:(id)videoInfo {
    [[MobileDB dbInstance] saveVideo:
            [[ABVideo alloc] initWithVideoID:[YoutubeParser getWatchVideoId:videoInfo]
                                  videoTitle:[YoutubeParser getVideoSnippetTitle:videoInfo]
                                channelTitle:[YoutubeParser getVideoSnippetChannelTitle:videoInfo]
            ]
    ];
}


- (void)setLeftMenuControllerDelegate:(id)delegate {
    _leftViewController.delegate = delegate;
}


- (UINavigationController *)currentNavigationController {
    return _tabBarController.selectedViewController;
}


- (YTVideoDetailViewController *)makeVideoDetailViewController:(id)video {
    YTVideoDetailViewController *controller = [[YTVideoDetailViewController alloc] initWithVideo:video];
    controller.view.backgroundColor = [ClientUIHelper mainUIBackgroundColor];

    return controller;
}


- (void)pushAndResetControllers:(NSArray *)controllers {
    [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

    UINavigationController *navigationController = [self currentNavigationController];

    navigationController.viewControllers = nil;
    navigationController.viewControllers = controllers;
}


- (void)pushWithVideo:(id)video {
    [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

    YTVideoDetailViewController *controller = [self makeVideoDetailViewController:video];

    UINavigationController *navigationController = [self currentNavigationController];

    [navigationController pushViewController:controller animated:YES];
}


#pragma mark -
#pragma mark GYoutubeHelperDelegate


- (void)callbackAfterFetchingAuthorSubscriptionListCompletion:(NSArray *)subscriptionList {
    [_leftViewController insertSubscriptionRowsAfterFetching:subscriptionList];
}


- (void)callbackUpdateYoutubeChannelCompletion:(YoutubeAuthInfo *)info {
    [_leftViewController refreshChannelInfo:info];
}

@end
