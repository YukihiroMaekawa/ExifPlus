//
//  AppDelegate.m
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSNotification* ns = [NSNotification
                          notificationWithName:@"applicationDidEnterBackground" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:ns];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSNotification* ns = [NSNotification
                          notificationWithName:@"applicationWillEnterForeground" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:ns];
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
