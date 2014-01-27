//
//  AppDelegate.m
//  BHRevealTableViewCell
//
//  Created by Brian Hammond on 1/27/14.
//  Copyright (c) 2014 Fictorial. All rights reserved.
//

#import "AppDelegate.h"
#import "BHDemoTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];

  BHDemoTableViewController *tableVC =
      [[BHDemoTableViewController alloc] initWithStyle:UITableViewStylePlain];

  UINavigationController *navigationVC =
      [[UINavigationController alloc] initWithRootViewController:tableVC];

  self.window.rootViewController = navigationVC;
  [self.window makeKeyAndVisible];

  return YES;
}

@end
