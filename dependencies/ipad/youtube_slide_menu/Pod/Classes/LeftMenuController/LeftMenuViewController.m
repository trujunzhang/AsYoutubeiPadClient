//
//  LeftMenuViewController.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//


#import "LeftMenuViewController.h"

#import "STCollapseTableView.h"
#import "LeftMenuItemTree.h"
#import "YTLeftRowTableViewCell.h"

static NSString * const leftmenuIdentifier = @"LeftMenuViewIdentifier";


@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) STCollapseTableView * tableView;


@end


@implementation LeftMenuViewController


- (void)setupTableViewExclusiveState {
   [self.tableView setExclusiveSections:NO];
   for (int i = 0; i < [self.tableSectionArray count]; i++) {
      [self.tableView openSection:i animated:NO];
   }
}


- (instancetype)init {
   if (!(self = [super init]))
      return nil;

   self.tableView = [[STCollapseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
   self.tableView.DataSource = self;
   self.tableView.Delegate = self;


   [self.tableView registerClass:[YTLeftRowTableViewCell class] forCellReuseIdentifier:leftmenuIdentifier];


   return self;
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self.tableSectionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   YTLeftRowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:leftmenuIdentifier];
   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftmenuIdentifier];
   }

   LeftMenuItemTree * menuItemTree = self.tableSectionArray[indexPath.section];
   NSArray * line = menuItemTree.rowsArray[indexPath.row];

   [cell   bind:line[0]
      withLineIconUrl:line[1]
        isRemoteImage:menuItemTree.isRemoteImage
             cellSize:CGSizeMake(250, ROW_HEIGHT)
nodeConstructionQueue:self.nodeConstructionQueue];

   cell.backgroundColor = [UIColor clearColor];

   return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section];

   return menuItemTree.rowsArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return ROW_HEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section];
   if (menuItemTree.hideTitle) {
      return 0;
   }

   return 42;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   return [self.headers objectAtIndex:section];
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   NSInteger section = indexPath.section;
   NSInteger row = indexPath.row;

   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section];
   NSArray * line = menuItemTree.rowsArray[row];

   LeftMenuItemTreeType itemType = menuItemTree.itemType;
   switch (itemType) {
      case LMenuTreeUser:
         [self.delegate startToggleLeftMenuWithTitle:[LeftMenuItemTree getTitleInRow:line]
                                            withType:[LeftMenuItemTree getTypeInRow:line]];
         break;
      case LMenuTreeSubscriptions: {
         [self.delegate endToggleLeftMenuEventForChannelPageWithChannelId:[LeftMenuItemTree getChannelIdUrlInRow:line]
                                                                withTitle:[LeftMenuItemTree getTitleInRow:line]];
      }
         break;
      case LMenuTreeCategories: {
      }
   }
}


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
   [self.tableView reloadData];

   [self setupTableViewExclusiveState];
}


- (void)leftMenuSignOutTable {
   [self.tableView reloadData];

   [self setupTableViewExclusiveState];
}


- (void)leftMenuUpdateSubscriptionSection:(NSArray *)subscriptionList {
   [self.tableView reloadData];

   [self setupTableViewExclusiveState];
}

@end
