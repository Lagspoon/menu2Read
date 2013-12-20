//
//  menuAppDelegate.m
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//
///////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////
#import "menuAppDelegate.h"
#import "menuMasterViewController.h"
#import "MEAppConductor.h"

@interface menuAppDelegate()

@end



@implementation menuAppDelegate

///////////////////////////////////////////////////////////////////
// DETAIL AND MASTER VIEW MANAGEMENT FOR SPLITVIEW CONTROLLER
// FIRST CALL TO SYNCENGINE
///////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Initialisation of the appConductor to listen the notification of the different modules of the app
    dispatch_queue_t syncQueue = dispatch_queue_create("syncProcess",NULL);
    dispatch_async(syncQueue, ^{

        MEAppConductor* appConductor = [[MEAppConductor alloc]init];
        [appConductor register2Sync];
        [appConductor start2Sync];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
    //UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    //UIViewController *detailPVC = [splitViewController.viewControllers lastObject];
    //splitViewController.delegate = (id)detailPVC;
    });
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}


@end
