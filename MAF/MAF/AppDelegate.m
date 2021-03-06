//
//  AppDelegate.m
//  MAF
//
//  Created by Eddie Freeman on 7/3/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Crittercism.h"
#import <Parse/Parse.h>
#import "MainViewController.h"

#import "Goal.h"
#import "Transaction.h"
#import "TransactionCategory.h"
#import "TransactionCategoryManager.h"
#import "User.h"
#import "Post.h"
#import "Comment.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    static NSString *CRITTERCISM_APP_ID;
    static NSString *PARSE_APP_ID;
    static NSString *PARSE_CLIENT_KEY;
    
    /* read in api config from plist */
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"ServicesConfig.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
    plistPath = [[NSBundle mainBundle] pathForResource:@"ServicesConfig" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                        propertyListFromData:plistXML
                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                        format:&format
                                        errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, (unsigned long)format);
    }
    CRITTERCISM_APP_ID = [temp objectForKey:@"CRITTERCISM_APP_ID"];
    PARSE_APP_ID = [temp objectForKey:@"PARSE_APP_ID"];
    PARSE_CLIENT_KEY = [temp objectForKey:@"PARSE_CLIENT_ID"];

  // Uncomment when we're ready to capture services/crash reports
//    [Crittercism enableWithAppID:CRITTERCISM_APP_ID];
  
    // Register PFClasses
    [Goal registerSubclass];
    [Transaction registerSubclass];
    [TransactionCategory registerSubclass];
    [User registerSubclass];
    [Post registerSubclass];
    [Comment registerSubclass];
    [Parse setApplicationId:PARSE_APP_ID
              clientKey:PARSE_CLIENT_KEY];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // trigger fetching of categories
    [[TransactionCategoryManager instance] fetchCategories];
    
    // setup view controller
    MainViewController *vc = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.navigationBar.translucent = NO;
    self.window.rootViewController = navController;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.window makeKeyAndVisible];
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
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
