//
//  menuDetailPVC.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "MEPageViewController.h"

/*
 SubstitutableDetailViewController defines the protocol that detail view controllers must adopt.
 The protocol specifies aproperty for the bar button item controlling the navigation pane.
 */

@interface menuDetailPVC : MEPageViewController <UISplitViewControllerDelegate>
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

@end
