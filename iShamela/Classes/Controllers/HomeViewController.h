//
//  HomeViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 4/4/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"
#import "BookInfo.h"
#import "Category.h"
#import "TOC.h"
#import "TOCviewController.h"
#import "BookViewController.h"
#import "iShamelaAppDelegate.h"

@class DbManager;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> { 
    UISegmentedControl *segmentedCategoryView;
    UITableView *aTableView;
	UISearchBar *aSearchBar;
	DbManager *dbManager;
	BookInfo *bookInfo;
	Category *categoryInfo;
	
    iShamelaAppDelegate *delegateObj;
    
	NSMutableArray *downloadedBooks;
	
	NSMutableArray *categoryItem;
	
	
	//NSMutableArray *categoryLibaray;
    NSInteger recordCounter;
    BOOL refresh;
	
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedCategoryView;
@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *aSearchBar;
@property (nonatomic, retain) Category *categoryInfo;
@property (nonatomic, retain) BookInfo *bookInfo;
//@property (nonatomic, retain) NSMutableArray *categoryLibrary;
//@property (nonatomic, retain) NSMutableArray *downloadedBooks;


- (IBAction)categorySelectionChanged:(id)sender;

//-(void) fetchLibrary;
-(void) fetchCategories;
-(void)downloadCategories;
-(void) deleteBooks:(NSIndexPath *)indexPath;

@end
