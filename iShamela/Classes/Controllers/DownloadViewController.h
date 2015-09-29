//
//  DownloadViewController.h
//  iShamela
//
//  Created by Imran Bashir on 10/25/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"
#import "BookInfo.h"
#import "Category.h"
#import "TOC.h"
#import "TOCviewController.h"
#import "BookViewController.h"
#import "ShLibrary.h"
#import "iShamelaAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@class DbManager;

@interface DownloadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate>  {
	UISegmentedControl *segmentedCategoryView;
    UITableView *aTableView;
	UISearchBar *aSearchBar;
	DbManager *dbManager;
	BookInfo *bookInfo;
	Category *categoryInfo;
	iShamelaAppDelegate *delegateObj;
	ASINetworkQueue *networkQueue;
	
	NSMutableArray *downloadedBooks;
	NSMutableArray *bookItems;
	NSMutableArray *categoryItem;
	NSMutableArray *bookLibrary;
	NSMutableArray *categoryLibaray;
    NSMutableArray *progressBar;
	
    UIProgressView *progress;
	BOOL downloaded;
	BOOL inQueue;
	BOOL downloading;
	BOOL isCategory;
	
	NSInteger recordCounter;
    NSInteger downloadCounter;
    NSInteger progressBarIndex;
	
	
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedCategoryView;
@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *aSearchBar;
//@property (nonatomic, retain) iShamelaAppDelegate *delegateObj;

- (IBAction)categorySelectionChanged:(id)sender;

-(void) fetchLibrary;
-(void) fetchCategories;
-(void) requestDownload;

@end
