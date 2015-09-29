//
//  iShamelaAppDelegate.h
//  iShamela
//
//  Created by Suhendra Ahmad on 4/4/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iShamelaAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	
	NSMutableArray *DownloadBooks;
    NSMutableArray *categoryLibaray;


}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *DownloadBooks;
@property (nonatomic, retain) NSMutableArray *categoryLibaray;

@end
