//
//  iShamelaAppDelegate.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/4/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "iShamelaAppDelegate.h"
#import "DbManager.h"
#import "SSZipArchive.h"
#import "ShLibrary.h"

@implementation iShamelaAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;
@synthesize navController = _navController;

@synthesize DownloadBooks, categoryLibaray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    
    DownloadBooks = [[NSMutableArray alloc] init];
    categoryLibaray = [[NSMutableArray alloc] init];
	[DbManager duplicateAttachedBooks];
            /*
    NSError *error;
    [SSZipArchive unzipFileAtPath:[DbManager getUserDocumentPathWithFileName:@"5555.azx"] 
                     withFileName:@"Manifest.plist"
                    toDestination:[[NSBundle mainBundle] resourcePath]
                       toFileName:@"5555.azx.plist"
                            error:&error];
*/
    
    [[ShLibrary sharedLibrary] reloadBooks];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"recordCounter"];
	//NSLog(@"it is ciuntrt %@",myString);
	if (!myString) {
        // saving an NSString
        [prefs setObject:@"100" forKey:@"recordCounter"];
        [prefs synchronize];

    }
    
    myString = [prefs stringForKey:@"searchCounter"];
	//NSLog(@"it is ciuntrt %@",myString);
	if (!myString) {
        // saving an NSString
        [prefs setObject:@"250" forKey:@"searchCounter"];
        [prefs synchronize];
        
    }
    
    myString = [prefs stringForKey:@"fontSize"];
	//NSLog(@"it is ciuntrt %@",myString);
	if (!myString) {
        // saving an NSString
        [prefs setObject:@"16" forKey:@"fontSize"];
        [prefs synchronize];
        
    }
    
    myString = [prefs stringForKey:@"fontColor"];
	//NSLog(@"it is ciuntrt %@",myString);
	if (!myString) {
        // saving an NSString
        [prefs setObject:@"Black Color" forKey:@"fontColor"];
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]];
        [prefs setObject:colorData forKey:@"colorCode"];

        [prefs synchronize];
    }

    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
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

- (void)dealloc
{
    [DownloadBooks release];
    [categoryLibaray release];
    [_window release];
    [_tabBarController release];
    
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
