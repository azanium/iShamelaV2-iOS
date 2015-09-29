//
//  BookViewController.h
//  iShamela
//
//  Created by Imran Bashir on 10/21/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"
#import "BookInfo.h"
#import "Category.h"
#import "TOC.h"
#import "TOCviewController.h"
#import "ShLibrary.h"
#import "iShamelaAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"


@class DbManager;
@interface BookViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> { 
	
	UITableView *aTableView;
	UISearchBar *aSearchBar;
	
	DbManager *dbManager;
	BookInfo *bookInfo;
	Category *categoryInfo;
	iShamelaAppDelegate *delegateObj;
	ASINetworkQueue *networkQueue;

	NSString *isdownloaded;
	
	NSMutableArray *downloadedBooks;
	NSMutableArray *bookItems;
	NSMutableArray *bookLibrary;
	
	BOOL downloaded;
	BOOL inQueue;
	
	NSInteger recordCounter;
}


@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *aSearchBar;

@property (nonatomic, retain) Category *categoryInfo;
@property (nonatomic, retain) NSString *isdownloaded;

-(void) fetchLibrary;
-(void) requestDownload;


@end
