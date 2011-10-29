//
//  AppDelegate.m
//  ThaiWords
//
//  Created by Xinming Zhao on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "ThaiWord.h"
#import "FeedsController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self initializeDataMappping];

    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    [localControllersArray addObject:[[[UINavigationController alloc] initWithRootViewController: 
                                       [[[RootViewController alloc] initWithName:@"Vocabs" completed:NO] autorelease]
                                       ] autorelease]];
    
    [localControllersArray addObject:[[[UINavigationController alloc] initWithRootViewController: 
                                       [[[RootViewController alloc] initWithName:@"Review" completed:YES] autorelease]
                                       ] autorelease]];

    [localControllersArray addObject:[[[UINavigationController alloc] initWithRootViewController:
                                       [[[FeedsController alloc] initWithStyle:UITableViewStylePlain] autorelease]] autorelease]];
    
    
    for (UINavigationController *(navCon) in localControllersArray) {
        navCon.navigationBar.tintColor = [UIColor colorWithWhite:0.3 alpha:1];
        navCon.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
        navCon.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
        navCon.navigationBar.layer.shadowOpacity = 0.75;
        navCon.navigationBar.layer.shadowRadius = 2;
        navCon.navigationBar.layer.shouldRasterize = YES;
    }
    
    [tabController setViewControllers:localControllersArray];

    
    [self.window addSubview:tabController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initializeDataMappping
{
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:@"http://ohho.in.th:5000"];
    [[manager router] routeClass:[ThaiWord class] toResourcePath:@"/thai_words/:identifier" forMethod:RKRequestMethodPUT];
    [[manager router] routeClass:[ThaiWord class] toResourcePath:@"/thai_words" forMethod:RKRequestMethodPOST];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[ThaiWord class]];
    [mapping mapKeyPath:@"thai_word[is_done]" toAttribute:@"isDone"];
    [mapping mapKeyPath:@"thai_word[word]" toAttribute:@"word"];
    [manager.mappingProvider setSerializationMapping:[mapping inverseMapping] forClass:[ThaiWord class]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
