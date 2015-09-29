//
//  SearchViewController.h
//  iShamela
//
//  Created by Suhendra Ahmad on 4/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"
#import "BookInfo.h"
#import "Category.h"
#import "TOC.h"
#import "TOCviewController.h"
#import "BookViewController.h"


@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    UISegmentedControl *segmentedCategoryView;
    UITableView *aTableView;
	UISearchBar *aSearchBar;
	DbManager *dbManager;
	BookInfo *bookInfo;
	Category *categoryInfo;
	TOC *TOCinfo;
	
	NSMutableArray *bookTOC;
	NSMutableArray *downloadedBooks;
	
	NSMutableArray *categoryItem;
	NSMutableArray *autherItems;
	
	NSMutableArray *categoryLibaray;
	NSMutableArray *autherLibrary;
	
	NSInteger recordCounter;
    NSInteger searchCounter;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedCategoryView;
@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *aSearchBar;
@property (nonatomic, retain) NSMutableArray *bookTOC;
- (IBAction)categorySelectionChanged:(id)sender;

-(void) fetchLibrary;
-(void) fetchCategories;
-(void) searchInCategory:(NSString *)bookID SearchText:(NSString *)searchText;
@end
