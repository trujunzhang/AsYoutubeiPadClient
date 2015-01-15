#import <UIKit/UIKit.h>


@interface MxTabBarManager : NSObject

+ (MxTabBarManager *)sharedTabBarManager;

- (void)registerTabBarController:(UITabBarController *)tabBarController withLeftViewController:(id)leftViewController;

- (void)setLeftMenuControllerDelegate:(id)delegate;

- (UINavigationController *)currentNavigationController;

- (id)makeVideoDetailViewController:(id)video;

- (void)pushAndResetControllers:(NSArray *)controllers;

- (void)pushWithVideo:(id)video;
@end
