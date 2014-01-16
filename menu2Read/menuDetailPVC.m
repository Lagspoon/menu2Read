//
//  menuDetailPVC.m
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//
#import "menuDetailPVC.h"
#import "menuPageBig.h"
#import "Drink.h"

@interface menuDetailPVC ()
// Holds a reference to the split view controller's bar button item
// if the button should be shown (the device is in portrait).
// Will be nil otherwise.
@property (nonatomic, retain) UIBarButtonItem *navigationPaneButtonItem;
// Holds a reference to the popover that will be displayed
// when the navigation button is pressed.
@property (strong, nonatomic) UIPopoverController *navigationPopoverController;
@end

@implementation menuDetailPVC


//-------------------------------------------------------------------------------
//	setDetailViewController:
//  Custom implementation of the setter for the detailViewController property.
// -------------------------------------------------------------------------------
/*
- (void)setMenuDetailPVC:(UIViewController *)menuDetailPVC
{

    // Clear any bar button item from the detail view controller that is about to
    // no longer be displayed.
    self.menuDetailPVC.navigationPaneBarButtonItem = nil;

    _menuDetailPVC = menuDetailPVC;

    // Set the new detailViewController's navigationPaneBarButtonItem to the value of our
    // navigationPaneButtonItem.  If navigationPaneButtonItem is not nil, then the button
    //will be displayed.

    _menuDetailPVC.navigationPaneBarButtonItem = self.navigationPaneButtonItem;

    // Update the split view controller's view controllers array.
    // This causes the new detail view controller to be displayed.

    UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, _menuDetailPVC, nil];
    self.splitViewController.viewControllers = viewControllers;

    // Dismiss the navigation popover if one was present.  This will
    // only occur if the device is in portrait.
    if (self.navigationPopoverController)
        [self.navigationPopoverController dismissPopoverAnimated:YES];


}
*/
////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    //The detailPVC become the SVC delegate
    self.splitViewController.delegate = self;




    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self.modelController;

    if ([self.modelController.dataForPages count]==0) {
        self.modelController.dataForPages = [NSMutableArray arrayWithObject:@{@"viewControllerId": @"menuWelcome"}];
    }
    menuPageBig *startingViewController = (menuPageBig *)[self.modelController viewControllerAtIndex:0];

    //Crash if startingViewCOntroller is nil : first element of an array cannot be nil
    if (startingViewController) {
    [self.pageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    // Set the page view controller's bounds.
    self.pageViewController.view.frame = self.view.bounds;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the  view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;


}



////////////////////////////////////////////////////////////////////////
//SPLIT VIEW CONTROLLER DELEGATE MANAGEMENT
#pragma mark-splitViewController delegate
////////////////////////////////////////////////////////////////////////

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}


- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    // If the barButtonItem does not have a title (or image) adding it to a toolbar
    // will do nothing.
    barButtonItem.title = @"Navigation";

    self.navigationPaneButtonItem = barButtonItem;
    self.navigationPopoverController = popoverController;

    // Tell the detail view controller to show the navigation button.
    self.navigationPaneBarButtonItem = barButtonItem;
}


- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationPaneButtonItem = nil;
    self.navigationPopoverController = nil;

    // Tell the detail view controller to remove the navigation button.
    self.navigationPaneBarButtonItem = nil;
}


@end
