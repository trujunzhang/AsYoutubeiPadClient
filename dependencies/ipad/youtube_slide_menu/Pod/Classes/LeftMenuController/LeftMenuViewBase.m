//
//  LeftMenuViewBase.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "LeftMenuViewBase.h"

#import "UserInfoView.h"
#import "LeftMenuItemTree.h"
#import "LeftMenuTableHeaderView.h"
#import "YoutubeAuthDataStore.h"
#import "YoutubeAuthInfo.h"
#import "GYoutubeHelper.h"


@interface LeftMenuViewBase ()<UserInfoViewSigningOutDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) ASImageNode *imageNode;

@end


@implementation LeftMenuViewBase


- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(self.baseTableView, @"not found uitableview instance!");

    _imageNode = [[ASImageNode alloc] init];
    _imageNode.image = [UIImage imageNamed:@"mt_side_menu_bg"];

    _imageNode.frame = self.view.frame;// used
    _imageNode.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;


    [self.view addSubview:_imageNode.view];
    [self.view addSubview:self.baseTableView];
}


- (void)setCurrentTableView:(UITableView *)tableView {
    self.baseTableView = tableView;

    self.baseTableView.backgroundColor = [UIColor clearColor];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.showsVerticalScrollIndicator = NO;
}


- (void)viewWillLayoutSubviews {

}


#pragma mark -
#pragma mark setup


- (void)setupSlideTableViewWithAuthInfo:(YoutubeAuthInfo *)user {
    if(user == nil)
        user = [[[YoutubeAuthDataStore alloc] init] readAuthUserInfo];

    self.baseTableView.tableHeaderView = [self getUserHeaderView:user];
}


- (void)makeDefaultTableSections { // initialize once
    // 1  make section array
    if([[GYoutubeHelper getInstance] isSignedIn]) {
        self.tableSectionArray = [LeftMenuItemTree getSignInMenuItemTreeArray];
    } else {
        self.tableSectionArray = [LeftMenuItemTree getSignOutMenuItemTreeArray];
    }

    // 2 section header titles
    self.headers = [[NSMutableArray alloc] init];
    for (int i = 0;i < [self.tableSectionArray count];i++) {
        LeftMenuItemTree *menuItemTree = self.tableSectionArray[i];

        LeftMenuTableHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuTableHeaderView"
                                                                         owner:nil
                                                                       options:nil] lastObject];
        [header setupUI:menuItemTree.title];
        [self.headers addObject:header];
    }

}


#pragma mark -
#pragma mark Youtube auth login events


- (UIView *)getUserHeaderView:(YoutubeAuthInfo *)user {

    UIView *headerView = nil;

    if([[GYoutubeHelper getInstance] isSignedIn]) {
        UserInfoView *userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:nil
                                                                  options:nil] lastObject];
        userInfoView.delegate = self;
        headerView = [userInfoView bind:user];
    } else {
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserLoginView" owner:nil options:nil] lastObject];

        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleTap:)];
        [headerView addGestureRecognizer:singleFingerTap];
    }

    headerView.frame = CGRectMake(0, 0, 256, 70);

    return headerView;
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self loginInTouch];
}


- (void)loginInTouch {
    GTMOAuth2ViewControllerTouch *viewController =
            [[GYoutubeHelper getInstance] getYoutubeOAuth2ViewControllerTouchWithTouchDelegate:self
                                                                               leftBarDelegate:self
                                                                                  cancelAction:@selector(cancelGdriveSignIn:)];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.view.backgroundColor = [UIColor whiteColor];
    navigationController.modalPresentationStyle = UIModalPresentationPageSheet;

    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)viewController:(UIViewController *)viewController
      finishedWithAuth:(YTOAuth2Authentication *)auth
                 error:(NSError *)error {
    [self cancelGdriveSignIn:nil];

    if(error != nil) {
        // Authentication failed
        NSLog(@"failed");
    } else {
        // Authentication succeeded
        NSLog(@"Success");

        [[GYoutubeHelper getInstance] saveAuthorizeAndFetchUserInfo:auth];
    }
}


- (void)cancelGdriveSignIn:(id)cancelGdriveSignIn {
    [self dismissViewControllerAnimated:YES completion:^(void) {
    }];
}


#pragma mark -
#pragma mark Async refresh Table View


- (void)defaultRefreshForSubscriptionList {
    [self setupSlideTableViewWithAuthInfo:nil];
    [self makeDefaultTableSections];

    [self leftMenuReloadTable];
}


- (void)removeWhenSignOut {
    [self setupSlideTableViewWithAuthInfo:nil];
//   [self makeDefaultTableSections];

    [self leftMenuSignOutTable];
}


- (void)insertSubscriptionRowsAfterFetching:(NSArray *)subscriptionList {
    if([[GYoutubeHelper getInstance] isSignedIn] == NO)
        return;

    [LeftMenuItemTree reloadSubscriptionItemTree:subscriptionList inSectionArray:self.tableSectionArray];

    [self leftMenuUpdateSubscriptionSection:subscriptionList];

    // test
//   if (debugLeftMenuTapSubscription) {
//      if (subscriptionList.count > subscriptionIndex) {
//         [self.delegate endToggleLeftMenuEventForChannelPageWithChannelId:[LeftMenuItemTree getChannelIdUrlInRow:subscriptionList[subscriptionIndex]]
//                                                                withTitle:[LeftMenuItemTree getTitleInRow:subscriptionList[subscriptionIndex]]];
//      }
//   }

}


- (void)refreshChannelInfo:(YoutubeAuthInfo *)info {
    [self setupSlideTableViewWithAuthInfo:info];
}


#pragma mark -
#pragma mark UserInfoViewSigningOutDelegate


- (void)signingOutTapped {
    UIAlertView *myAlert = [[UIAlertView alloc]
            initWithTitle:@"Title"
                  message:@"Message"
                 delegate:self
        cancelButtonTitle:@"Cancel"
        otherButtonTitles:@"Ok", nil];

    [myAlert show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
    }
    else if(buttonIndex == 1) {
        [[GYoutubeHelper getInstance] signingOut];
        [self removeWhenSignOut];
    }
}


@end
