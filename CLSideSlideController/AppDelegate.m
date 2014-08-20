//
//  AppDelegate.m
//  CLSideSlideController
//
//  Created by L on 14-8-19.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftTableViewController.h"
#import "RightViewController.h"

#import "FirstViewController.h"
#import "SecondTableViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
#import "FiveTableViewController.h"
#import "SixViewController.h"
#import "SevenTableViewController.h"
#import "EightViewController.h"
#import "NineTableViewController.h"
#import "TenViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSMutableArray *array = [NSMutableArray array];
    
    FirstViewController *first = [[FirstViewController alloc] init];
    first.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    first.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [first setLeftBarItemShowLeftView:NO];
    [first setRightBarItemShowRightView:NO];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:first];
    [array addObject:firstNav];
    [first release];
    [firstNav release];
    
    SecondTableViewController *second = [[SecondTableViewController alloc] init];
    second.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    second.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [second setLeftBarItemShowLeftView:NO];
    [second setRightBarItemShowRightView:NO];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:second];
    [array addObject:secondNav];
    [second release];
    [secondNav release];
    
    ThirdViewController *third = [[ThirdViewController alloc] init];
    [array addObject:third];
    [third release];
    
    FourViewController *four = [[FourViewController alloc] init];
    four.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    four.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [four setLeftBarItemShowLeftView:YES];
    [four setRightBarItemShowRightView:YES];
    UINavigationController *fourNav = [[UINavigationController alloc] initWithRootViewController:four];
    [array addObject:fourNav];
    [four release];
    [fourNav release];
    
    FiveTableViewController *five = [[FiveTableViewController alloc] init];
    [array addObject:five];
    [five release];
    
    SixViewController *six = [[SixViewController alloc] init];
    six.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    six.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [six setLeftBarItemShowLeftView:YES];
    [six setRightBarItemShowRightView:YES];
    UINavigationController *sixNav = [[UINavigationController alloc] initWithRootViewController:six];
    [array addObject:sixNav];
    [six release];
    [sixNav release];
    
    SevenTableViewController *seven = [[SevenTableViewController alloc] init];
    seven.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    seven.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [seven setLeftBarItemShowLeftView:YES];
    [seven setRightBarItemShowRightView:YES];
    UINavigationController *sevNav = [[UINavigationController alloc] initWithRootViewController:seven];
    [array addObject:sevNav];
    [seven release];
    [sevNav release];
    
    
    EightViewController *eight = [[EightViewController alloc] init];
    [array addObject:eight];
    [eight release];
    
    
    NineTableViewController *nine = [[NineTableViewController alloc] init];
    [array addObject:nine];
    [nine release];
    
    TenViewController *ten = [[TenViewController alloc] init];
    ten.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    ten.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [ten setLeftBarItemShowLeftView:YES];
    [ten setRightBarItemShowRightView:YES];
    UINavigationController *tenNav = [[UINavigationController alloc] initWithRootViewController:ten];
    [array addObject:tenNav];
    [ten release];
    [tenNav release];
    
    
    //==================
    LeftTableViewController *left = [[LeftTableViewController alloc] init];
    //UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:left];
    
    RightViewController *right = [[RightViewController alloc] init];
    
    
    //=======================
    CLSideSlideController *tabbar = [[CLSideSlideController alloc] init];
    tabbar.delegate = self;
    tabbar.viewControllers = array;
    tabbar.leftViewController = left;
    tabbar.rightViewController = right;
    
    
    tabbar.leftViewWidth = 200;
    tabbar.rightViewWidth = 200;
    //    tabbar.leftViewFillScreen = NO;
    //    tabbar.rightViewFillScreen = NO;
    
    //tabbar.animationType = SideSlidShowViewAnimationScale;
    //tabbar.animationType = CLSideSlideShowViewAnimationFor7;
    //tabbar.animationType = SideSlidShowViewAnimationParallax;
    
    //    tabbar.showMianViewShadow = NO;
    tabbar.showLeftViewShadow = YES;
    tabbar.showRightViewShadow = YES;
    
    //    tabbar.scrollContinuous = NO;
    
    //    tabbar.canTouchWhenShow = NO;
    
    //    tabbar.showMainViewMask = YES;
    //    tabbar.showLeftViewMask = YES;
    //    tabbar.showRightViewMask = YES;
    
    tabbar.view.backgroundColor = [UIColor orangeColor];
    //    tabbar.backgroundImage = @"2222.png";//@"MenuBackground.png";
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:tabbar];
    rootNav.navigationBarHidden = YES;
    self.window.rootViewController = rootNav;
    [tabbar selectViewControllerAtIndex:1];
    [tabbar selectViewControllerAtIndex:0];
    
    [left release];
    //[leftNav release];
    
    [right release];
    
    [tabbar release];
    
    
    //    TestTableViewController *test = [[TestTableViewController alloc] init];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:test];
    //    self.window.rootViewController = nav;
    //    [test release];
    //    [nav release];
    
    return YES;
}

- (void)sideSlideController:(CLSideSlideController *)sideSlideController willShowLeftViewController:(BOOL)isLeft
{
    NSLog(@"将要显示=== %@", sideSlideController);
    if (isLeft) {
        NSLog(@"将要显示左视图");
    }else
        NSLog(@"将要显示右视图");
}

- (void)sideSlideController:(CLSideSlideController *)sideSlideController didShowLeftViewController:(BOOL)isLeft
{
    NSLog(@"已经显示=== %@", sideSlideController);
    if (isLeft) {
        NSLog(@"已经显示左视图");
    }else
        NSLog(@"已经显示右视图");
}

- (void)sideSlideController:(CLSideSlideController *)sideSlideController willHideLeftViewController:(BOOL)isLeft
{
    NSLog(@"将要隐藏=== %@", sideSlideController);
    if (isLeft) {
        NSLog(@"将要隐藏左视图");
    }else
        NSLog(@"将要隐藏右视图");
}

- (void)sideSlideController:(CLSideSlideController *)sideSlideController didHideLeftViewController:(BOOL)isLeft
{
    NSLog(@"已经隐藏=== %@", sideSlideController);
    if (isLeft) {
        NSLog(@"已经隐藏左视图");
    }else
        NSLog(@"已经隐藏右视图");
}

- (void)didShowRootViewControllerForSideSlideController:(CLSideSlideController *)sideSlideController
{
    NSLog(@"已经显示主视图------- %@", sideSlideController);
}

- (void)willRotateSacleMianViewForSideSlideController:(CLSideSlideController *)sideSlideController
{
    NSLog(@"将要旋转缩放主视图++++++++ %@", sideSlideController);
}

- (void)didRotateScaleMainViewForSideSlideController:(CLSideSlideController *)sideSlideController
{
    NSLog(@"已经旋转缩放主视图++++++++ %@", sideSlideController);
}

- (void)willRecoverMainViewForSideSlideController:(CLSideSlideController *)sideSlideController
{
    NSLog(@"将要旋转放大主视图++++++++ %@", sideSlideController);
}

- (void)didRecoverMainViewForSideSlideController:(CLSideSlideController *)sideSlideController
{
    NSLog(@"已经旋转放大主视图++++++++ %@", sideSlideController);
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
