//
//  MEPageViewController.h
//  menu2Read
//
//  Created by Olivier Delecueillerie on 15/12/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "menuPageModel.h"

@interface MEPageViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) menuPageModel *modelController;

//- (UIPageControl *) pageControlInit;

@end
