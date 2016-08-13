//
//  AppDelegate.m
//  BNRTouchTracker
//
//  Created by YangJialin on 8/11/16.
//  Copyright © 2016 YangJialin. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BNRDrawViewController *dvc = [[BNRDrawViewController alloc] init];
    self.window.rootViewController = dvc;
    
    self.window.backgroundColor = [UIColor  whiteColor];
    [self.window makeKeyWindow];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BNRDrawView *lineView = self.window.rootViewController.view;
    if(lineView){
        BOOL success = lineView.saveChanges;
        if(success){
            NSLog(@"Saved all of the BNRLine");
        }else{
            NSLog(@"Could not save any of the BNRLine");
        }
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
