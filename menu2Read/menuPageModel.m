//
//  menuPageModel.m
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#define DEFINE_storyboardName_iPad @"menu_iPad"
#define DEFINE_storyboardName_iPhone @"menu_iPhone"

#import "menuPageModel.h"
#import "MEPage.h"

@interface menuPageModel()

@end

@implementation menuPageModel

////////////////////////////////////////////////////////////////////////////
//LAZY INSTANTIATION and INIT
#pragma mark-Lazy Instantiation and INIT
///////////////////////////////////////////////////////////////////////////
- (NSArray *) dataForPages {
    if(!_dataForPages) _dataForPages=[[NSMutableArray alloc] init];
    return _dataForPages;
}

- (menuPageModel *) initWithDataForPages :(NSMutableArray*) dataForPages {
    self = [super init];
    if (self) {
        // Create the data model.
        self.dataForPages = dataForPages;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////
//PAGE CREATION
///////////////////////////////////////////////////////////////////////////
- (MEPage*)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.dataForPages count] == 0) || (index >= [self.dataForPages count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    NSString *viewControllerId = [self.dataForPages[index] valueForKey:@"viewControllerId"];
    MEPage *viewController = [[MEPage alloc] init];

    if (viewControllerId)
        viewController  = [[UIStoryboard storyboardWithName:DEFINE_storyboardName_iPad bundle:NULL] instantiateViewControllerWithIdentifier:viewControllerId];

    viewController.dataDictionary = (NSDictionary *)self.dataForPages[index];

    return viewController;
}

- (NSUInteger)indexOfViewController:(MEPage *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.dataForPages indexOfObject:viewController.dataDictionary];
}

////////////////////////////////////////////////////////////////////////////
//Page View Controller Data Source DELEGATE
///////////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.index = [self indexOfViewController:(MEPage *)viewController];
    if ((self.index == 0) || (self.index == NSNotFound)) {
        self.index = [self.dataForPages count];
        return [self viewControllerAtIndex:self.index];
    }
    
    self.index--;
    return [self viewControllerAtIndex:self.index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.index = [self indexOfViewController:(MEPage *)viewController];
    if (self.index == NSNotFound) {
        return nil;
    }
    self.index++;
    if (self.index == [self.dataForPages count]) {
        self.index=0;
        return [self viewControllerAtIndex:self.index] ;
    }
    return [self viewControllerAtIndex:self.index];
}

///////////////////////////////////////////////////////////////////////////
//PAGE CONTROL DELEGATE
///////////////////////////////////////////////////////////////////////////
- (NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.index;
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.dataForPages.count;
}



@end
