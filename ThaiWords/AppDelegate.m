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
#import "FeedListController.h"
#import "NSArray+PerformSelector.h"

@interface AppDelegate ()
- (NSArray *)segmentViewControllers;
//- (void)firstUserExperience;
- (void)prepareSegmentsControllers;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize speaker;
@synthesize segmentedControl, segmentsController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeDataMappping];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    self.speaker = [[NSClassFromString(@"VSSpeechSynthesizer") alloc] init];
    [speaker setRate:[[[NSUserDefaults standardUserDefaults] objectForKey:@"speech_rate"] doubleValue]];
    UITabBarController *tabController = [[UITabBarController alloc] init];
    NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:2];
        
    [self prepareSegmentsControllers];
    
    [localControllersArray addObject: self.segmentsController.navigationController];

    [localControllersArray addObject:[[[UINavigationController alloc] initWithRootViewController:
                                       [[[FeedListController alloc] initWithStyle:UITableViewStylePlain] autorelease]] autorelease]];
    
    
    for (UINavigationController *(navCon) in localControllersArray) {
        navCon.navigationBar.tintColor = [UIColor colorWithWhite:0.3 alpha:1];
        navCon.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
        navCon.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
        navCon.navigationBar.layer.shadowOpacity = 0.75;
        navCon.navigationBar.layer.shadowRadius = 2;
        navCon.navigationBar.layer.shouldRasterize = YES;
    }
    
    [tabController setViewControllers:localControllersArray];
    [localControllersArray release];
    
    [self.window addSubview:tabController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initializeDataMappping
{
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:@"http://active-thai.herokuapp.com"];
//    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:@"http://localhost:3000"];
    [[manager router] routeClass:[ThaiWord class] toResourcePath:@"/thai_words" forMethod:RKRequestMethodPOST];
    [[manager router] routeClass:[ThaiWord class] toResourcePath:@"/thai_words/:identifier" forMethod:RKRequestMethodPUT];
    [[manager router] routeClass:[ThaiWord class] toResourcePath:@"/thai_words/:identifier" forMethod:RKRequestMethodDELETE];

    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[ThaiWord class]];
    [mapping setRootKeyPath:@""];
    [mapping mapKeyPath:@"thai_word[is_done]" toAttribute:@"isDone"];
    [mapping mapKeyPath:@"thai_word[word]" toAttribute:@"word"];
    [manager.mappingProvider setSerializationMapping:[mapping inverseMapping] forClass:[ThaiWord class]];
}



#pragma mark -
#pragma mark SegmentationViewControllers


- (NSArray *)segmentViewControllers {
    NSMutableArray* viewControllers = [[NSMutableArray alloc] initWithCapacity:3];
   [viewControllers addObject:[[[FlashCardListController alloc] initWithName:@"Newest" withViewType:VIEW_NEWEST] autorelease]];
   
   [viewControllers addObject:[[[FlashCardListController alloc] initWithName:@"Frequent" withViewType:VIEW_FREQUENT] autorelease]];

    [viewControllers addObject:[[[FlashCardListController alloc] initWithName:@"Review" withViewType:VIEW_REVIEW] autorelease]];
    return viewControllers;
}

- (void)prepareSegmentsControllers {
    UINavigationController * VocabNavigationController = [[[UINavigationController alloc] init] autorelease];
    
    NSArray * viewControllers = [self segmentViewControllers];
    self.segmentsController = [[SegmentsController alloc] initWithNavigationController:VocabNavigationController viewControllers:viewControllers];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:[viewControllers arrayByPerformingSelector:@selector(title)]];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    [self.segmentedControl addTarget:self.segmentsController
                              action:@selector(indexDidChangeForSegmentedControl:)
                    forControlEvents:UIControlEventValueChanged];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentsController indexDidChangeForSegmentedControl:self.segmentedControl];
}


#pragma mark - System Methods

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
    [speaker setRate:[[[NSUserDefaults standardUserDefaults] objectForKey:@"speech_rate"] doubleValue]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (void)speakWord:(NSString *) text{
    [speaker startSpeakingString:text toURL:nil withLanguageCode:@"th-TH"];
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    NSLog(@"did load object : %@", object);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"%@", error);
}



@end
