//
//  MxAsTubeAppDelegate.m
//  TubeIPadApp
//
//  Created by djzhang on 10/23/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "MxAsTubeAppDelegate.h"

#import <SWRevealViewController/SWRevealViewController.h>

#import "SubscriptionsViewController.h"
#import "LeftRevealHelper.h"
#import "CacheImageConstant.h"
#import "MxTabBarManager.h"
#import "ClientUIHelper.h"
#import "DebugUtils.h"
#import "CollectionConstant.h"


@interface MxAsTubeAppDelegate ()<UIApplicationDelegate, UITabBarControllerDelegate, SWRevealViewControllerDelegate> {
}

@property (nonatomic, strong) SWRevealViewController *revealController;


@end


@implementation MxAsTubeAppDelegate

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//   // Override point for customization after application launch.
//   self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//   // Override point for customization after application launch.
//
//   UIViewController * controller = [[YTLeftMenuViewController alloc] init];
//
//   [[MxTabBarManager sharedTabBarManager] registerTabBarController:nil
//                                            withLeftViewController:controller];
//
//   controller.view.backgroundColor = [UIColor redColor];
//
//   self.window.rootViewController = controller;
//
//   [self.window makeKeyAndVisible];
//
//   return YES;
//}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DebugUtils listAppHomeInfo];

    [YTCacheImplement removeAllCacheDiskObjects];

    //1
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.view.backgroundColor = [ClientUIHelper mainUIBackgroundColor];
    tabBarController.delegate = self;
    tabBarController.tabBar.tintColor = [UIColor redColor];
    tabBarController.selectedIndex = 0;// default is Subscription View Controller.

    if(!hasShowLeftMenu) {
        tabBarController.selectedIndex = 1; //test
    }

    //2. the first right tab bar item
    NSArray *controllers = tabBarController.viewControllers;
    for (UINavigationController *controller in controllers) {
        controller.view.backgroundColor = [UIColor clearColor];
    }

//   _subscriptionsViewController = ((UINavigationController *) tabBarController.viewControllers[0]).viewControllers[0];

//   NSString * debug = @"debug";

    //3
    YTLeftMenuViewController *leftViewController = [[YTLeftMenuViewController alloc] init];

    //6
    self.revealController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController
                                                                   frontViewController:tabBarController];
    self.revealController.delegate = self;

    [[LeftRevealHelper sharedLeftRevealHelper] registerRevealController:self.revealController];
    [[MxTabBarManager sharedTabBarManager] registerTabBarController:tabBarController
                                             withLeftViewController:leftViewController];

//   UINavigationController * navigationController=[[MxTabBarManager sharedTabBarManager] currentNavigationController];

    //7
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.revealController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
#pragma mark UITabBarControllerDelegate


- (void)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *controller = tabBarController.selectedViewController;

    [[LeftRevealHelper sharedLeftRevealHelper]
            beginTabBarToggleWithSelectedIndex:tabBarController.selectedIndex
                                 withViewCount:controller.viewControllers.count];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[LeftRevealHelper sharedLeftRevealHelper] endTabBarToggleWithSelectedIndex:tabBarController.selectedIndex];
}


@end
