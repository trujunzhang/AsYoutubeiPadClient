//
//  LeftMenuViewController.h
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LeftMenuViewBase.h"

@interface LeftMenuViewController : LeftMenuViewBase


@property(nonatomic, strong) NSOperationQueue * nodeConstructionQueue;
@end
