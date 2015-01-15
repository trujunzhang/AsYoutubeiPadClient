//
//  AsLeftMenuViewController.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//


#import "AsLeftMenuViewController.h"

#import "LeftMenuItemTree.h"
#import "YTAsLeftTableCellNode.h"


@interface AsLeftMenuViewController ()<ASTableViewDataSource, ASTableViewDelegate>
@property (nonatomic, strong) ASTableView *tableView;


@end


@implementation AsLeftMenuViewController


- (instancetype)init {
    if(!(self = [super init]))
        return nil;

    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.asyncDataSource = self;
    self.tableView.asyncDelegate = self;


    return self;
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableSectionArray count];
}


- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {

    LeftMenuItemTree *menuItemTree = self.tableSectionArray[indexPath.section];
    NSArray *line = menuItemTree.rowsArray[indexPath.row];


    YTAsLeftTableCellNode *node =
            [[YTAsLeftTableCellNode alloc]
                    initWithNodeCellSize:CGSizeMake(250, ROW_HEIGHT)
                               lineTitle:[LeftMenuItemTree getTitleInRow:line]
                             lineIconUrl:[LeftMenuItemTree getThumbnailUrlInRow:line]
                           isRemoteImage:menuItemTree.isRemoteImage];

    return node;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LeftMenuItemTree *menuItemTree = self.tableSectionArray[section];

    return menuItemTree.rowsArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    LeftMenuItemTree *menuItemTree = self.tableSectionArray[section];
    if(menuItemTree.hideTitle) {
        return 0;
    }

    return 42;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}


#pragma mark -
#pragma mark UITableViewDelegate


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//   NSInteger section = indexPath.section;
//   NSInteger row = indexPath.row;
//
//   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section];
//   NSArray * line = menuItemTree.rowsArray[row];
//
//   LeftMenuItemTreeType itemType = menuItemTree.itemType;
//   switch (itemType) {
//      case LMenuTreeUser:
//         [self.delegate startToggleLeftMenuWithTitle:[LeftMenuItemTree getTitleInRow:line]
//                                            withType:[LeftMenuItemTree getTypeInRow:line]];
//         break;
//      case LMenuTreeSubscriptions: {
//         [self.delegate endToggleLeftMenuEventForChannelPageWithChannelId:[LeftMenuItemTree getChannelIdUrlInRow:line]
//                                                                withTitle:[LeftMenuItemTree getTitleInRow:line]];
//      }
//         break;
//      case LMenuTreeCategories: {
//      }
//   }
//}


#pragma mark -
#pragma mark


- (void)viewDidLoad {
    [self setCurrentTableView:self.tableView];
    [self defaultRefreshForSubscriptionList];

    [super viewDidLoad];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    _tableView.frame = self.view.bounds;
}


#pragma mark -
#pragma mark Overrides


- (void)leftMenuReloadTable {


}


- (void)leftMenuSignOutTable {
//   [_tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:YES];

    NSArray *indexPaths = @[
            [NSIndexPath indexPathForItem:0 inSection:1],
    ];

//
//   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//       [_tableView deleteRowsAtIndexPaths:indexPaths
//                         withRowAnimation:YES];
//       // self.view isn't a node, so we can only use it on the main thread
//       dispatch_sync(dispatch_get_main_queue(), ^{
////           LeftMenuItemTree * itemTree = self.tableSectionArray[1];
////           NSMutableArray * rowsArray = itemTree.rowsArray;
////           [rowsArray removeObjectAtIndex:0];
//       });
//   });


}


- (void)leftMenuUpdateSubscriptionSection:(NSArray *)subscriptionList {
//   [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
//             withRowAnimation:YES];
}


@end
