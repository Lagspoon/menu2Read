//
//  MEPageViewController.m
//  menu2Read
//
//  Created by Olivier Delecueillerie on 15/12/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "MEPageViewController.h"

@interface MEPageViewController ()
@end

@implementation MEPageViewController

////////////////////////////////////////////////////////////////////////
//INIT and LAZY INSTANTIATION
#pragma mark-INIT and LAZY INSTANTIATION
////////////////////////////////////////////////////////////////////////

- (menuPageModel *)modelController {
    if (!_modelController) _modelController = [[menuPageModel alloc]init];
    return _modelController;
}

////////////////////////////////////////////////////////////////////////
//PAGE CONTROL MANAGEMENT
////////////////////////////////////////////////////////////////////////

- (UIPageControl *) pageControlInit {

    UIPageControl * pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = [self.modelController presentationCountForPageViewController:self.pageViewController];
    pageControl.currentPage = [self.modelController presentationIndexForPageViewController:self.pageViewController];
    return pageControl;
}


////////////////////////////////////////////////////////////////////////
//UIPageViewController DELEGATE METHOD
////////////////////////////////////////////////////////////////////////

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // In portrait orientation: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

@end
