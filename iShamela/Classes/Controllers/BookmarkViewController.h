//
//  BookmarkViewController.h
//  iShamela
//
//  Created by Imran Bashir on 10/17/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"
#import "BookInfo.h"
#import "TOC.h"
#import "BookMark.h"
#import "ContentViewController.h"
#import <sqlite3.h>


@interface BookmarkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate> {
	
	NSMutableArray *bookMarks;
	NSMutableArray *bookMarkItems;
	UITableView *aTableView;
	UISearchBar *aSearchBar;
	
	DbManager *db;
	BookMark *bookMark;
	
	NSInteger recordCounter;

}

@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *aSearchBar;




-(void) fetchBookMarks;
-(void) deleteBookMark:(NSIndexPath *)indexPath;
-(void) keyboardShown:(NSNotification *)note;
-(void) keyboardHidden:(NSNotification *)note ;
@end
