//
//  menuSmallPVC.m
//  menu
//
//  Created by Olivier Delecueillerie on 25/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#define DEFINE_viewControllerId @"menuPageSmall"
#import "menuSmallPVC.h"
#import "menuPageSmall.h"
#import "menuPageModel.h"
#import "SYCoreDataStackWithSyncStuff.h"

NSString * const kSDSyncEngineInitialCompleteKey2 = @"SDSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName2 = @"SDSyncEngineSyncCompleted";

@interface menuSmallPVC ()
@property (nonatomic, strong) SYCoreDataStackWithSyncStuff *dataController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
// Holds a reference to the split view controller's bar button item
// if the button should be shown (the device is in portrait).
// Will be nil otherwise.
@property (nonatomic, retain) UIBarButtonItem *navigationPaneButtonItem;
// Holds a reference to the popover that will be displayed
// when the navigation button is pressed.
@property (strong, nonatomic) UIPopoverController *navigationPopoverController;
@property (nonatomic) NSInteger index;

@end

@implementation menuSmallPVC

- (SYCoreDataStackWithSyncStuff *) dataController {
    if (!_dataController) _dataController = [[SYCoreDataStackWithSyncStuff alloc]init];
    return _dataController;
}

- (NSMutableArray *) createDataForPages {
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    NSArray *fetchedObjects = [self.fetchedResultsController fetchedObjects];
    for (int i=0; i<[fetchedObjects count]; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        id object = [fetchedObjects objectAtIndex:i];
        [dic setValue:object forKeyPath:@"object"];
        [dic setValue:DEFINE_viewControllerId forKeyPath:@"viewControllerId"];
        [mutableArray insertObject:dic atIndex:0];
    }
    return mutableArray;
}


////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.modelController = [[menuPageModel alloc ]initWithDataForPages:[self createDataForPages]];

    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self.modelController;






    if ([self.modelController.dataForPages count]==0)
        self.modelController.dataForPages = [NSMutableArray arrayWithObject:@{@"viewControllerId": @"menuWelcome"}];

    menuPageSmall *startingViewController = (menuPageSmall *)[self.modelController viewControllerAtIndex:0];

    //if startingViewController is empty it will crash
    if (startingViewController) {
        [self.pageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }


    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    // Set the page view controller's bounds.
    self.pageViewController.view.frame = self.view.bounds;
    
    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    [self createTimer];
    self.index = self.modelController.dataForPages.count;



    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kSDSyncEngineSyncCompletedNotificationName2 object:nil];
}


////////////////////////////////////////////////////////////////////////
//TIMER MANAGEMENT
////////////////////////////////////////////////////////////////////////
- (void) nextPage {
    self.index ++;
    NSUInteger i =self.index % self.modelController.dataForPages.count;
    menuPageSmall *viewController = (menuPageSmall*)[self.modelController viewControllerAtIndex:(i)];
    NSArray *viewControllers =@[viewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

//////////////////////////////////////////////////////////////////////////
//DATA MANAGEMENT
#pragma mark-DATA MANAGEMENT
///////////////////////////////////////////////////////////////////////////


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SquareMenuAd" inManagedObjectContext:self.dataController.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];

    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;


    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;
}



- (void)refresh {
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }

    self.modelController.dataForPages =[self createDataForPages];
    menuPageSmall *startingViewController = (menuPageSmall *)[self.modelController viewControllerAtIndex:0];

    //if startingViewController is empty it will crash
    if (startingViewController) {
        [self.pageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }


}


@end
