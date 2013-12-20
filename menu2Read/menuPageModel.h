//
//  menuPageModel.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface menuPageModel : NSObject <UIPageViewControllerDataSource>
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;
- (menuPageModel *) initWithDataForPages :(NSMutableArray*) dataForPages;
@property (strong, nonatomic) NSMutableArray *dataForPages; //mutableArray of Dictionary

@end
