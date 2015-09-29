//
//  TOCviewController.h
//  iShamela
//
//  Created by Imran Bashir on 10/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"
#import "BookInfo.h"
#import "TOC.h"
#import <sqlite3.h>
#import "ContentViewController.h"

@interface TOCviewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
	
	UISearchBar *aSearchBar;
    UITableView *aTableView;
	DbManager *db;
	BookInfo *bookInfo;
	TOC *TOCinfo;
	
	NSMutableArray *bookTOC;
	NSMutableArray *TOCItems;
	NSString *bookTitle;
	NSMutableArray *searchTOCItem;
	
	NSInteger recordCounter;

}

@property (nonatomic, retain) IBOutlet UISearchBar *aSearchBar;
@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) BookInfo *bookInfo;
@property (nonatomic, retain) TOC *TOCinfo;
@property (nonatomic, retain) NSString *bookTitle;
@property (nonatomic, retain) NSMutableArray *searchTOCItem;
@property (nonatomic, retain) NSMutableArray *TOCItems;

- (void)fetchBookTOC:(NSString *)bookID;
- (void) fetchSearched;
- (void)findBookIds:(NSInteger)index StartID:(NSString **)startId EndID:(NSString **)endId;



@end
