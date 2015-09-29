//
//  SearchViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "SearchViewController.h"


@implementation SearchViewController

@synthesize segmentedCategoryView, aTableView, aSearchBar;
@synthesize bookTOC;

- (IBAction)categorySelectionChanged:(id)sender
{
    //[bookTOC removeAllObjects];
    for (int i= 0; i< [categoryItem count]; i++) {
        categoryInfo = [categoryItem objectAtIndex:i];
		categoryInfo.selected = FALSE;	
    }
    
    for (int j = 0; j < [downloadedBooks count]; j++) {
        bookInfo = [downloadedBooks objectAtIndex:j];
		bookInfo.selected = FALSE;
    }
    [self.aTableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [bookTOC release];
	[downloadedBooks release];
	
	[categoryItem release];
	[autherItems release];
	
    [categoryLibaray release];
	[autherLibrary release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationItem.backBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"Back"
									  style: UIBarButtonItemStyleBordered
									 target:nil
									 action:nil] autorelease];
	if (downloadedBooks) {
		//[[ShLibrary sharedLibrary] reloadBooks];
		[downloadedBooks removeAllObjects];
		[downloadedBooks addObjectsFromArray:[ShLibrary sharedLibrary].bookList ];
		
	}
	
	
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	bookTOC = [[NSMutableArray alloc] init];
	categoryLibaray = [[NSMutableArray alloc] init];
	autherLibrary = [[NSMutableArray alloc] init];
	dbManager = [[DbManager alloc] init]; 
	
	
	[self fetchCategories];
	[self fetchLibrary];
	
	downloadedBooks = [[NSMutableArray alloc] initWithArray:[ShLibrary sharedLibrary].bookList ];
	categoryItem = [[NSMutableArray alloc] initWithArray:categoryLibaray];
	autherItems = [[NSMutableArray alloc] initWithArray:autherLibrary];
	
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"recordCounter"];
	
	recordCounter = [myString intValue];
    searchCounter = 0;
	
	
}

-(void) fetchLibrary
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	for (int i = 0; i< [[ShLibrary sharedLibrary].bookList count]; i++) {
		BookInfo *book = [[ShLibrary sharedLibrary].bookList objectAtIndex:i];
		
		if (![book.bookAuther isEqualToString:@""]) {
			[autherLibrary addObject:book];
			
		}
	}
	
	[pool release];
}

-(void)fetchCategories
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:@"library.sqlite"];
	
	NSString *query = [NSString stringWithFormat:@"select categoryId, categoryName, categoryOrder, categoryLevel from category"];
	
	[dbManager closeDB];
	
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *dbConnection= [dbManager openDb:pathToDb];
	
	const char *sql = [query UTF8String];
	BOOL done = NO;
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(selectstmt) == SQLITE_ROW && !done) {
			
			NSString *categoryId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			NSString *categoryName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
			NSString *categoryOrder = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
			NSString *categoryLevel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
			
			for (int i = 0; i< [[ShLibrary sharedLibrary].bookList count]; i++) {
				BookInfo *book = [[ShLibrary sharedLibrary].bookList objectAtIndex:i];
				
				if ([book.bookCategory isEqualToString:categoryId]) {
					categoryInfo = [Category categoryWithId:categoryId catOrd:categoryOrder level:categoryLevel name:categoryName];
					[categoryLibaray addObject:categoryInfo];
					break;
					
				}
			}
			
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
	[pool release];
	
	
	
}
-(void) keyboardShown:(NSNotification *)note {
	
	CGRect keyboardFram;
	[[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFram];
	CGRect tableViewFram = aTableView.frame;
	tableViewFram.size.height -= keyboardFram.size.height-40;
	[aTableView setFrame:tableViewFram];
	[aSearchBar setShowsCancelButton:YES animated:YES];
	
}

-(void) keyboardHidden:(NSNotification *)note {
	
	[aTableView setFrame:self.view.bounds];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.aTableView = nil;
    self.segmentedCategoryView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
#pragma mark -
#pragma mark Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedCategoryView.selectedSegmentIndex == 0)
    {
		
		if (recordCounter < [categoryItem count]) {
			return recordCounter +1;
		}else {
			return [categoryItem count];
		}
		
	}else{
		
		if (recordCounter < [downloadedBooks count]) {
			return recordCounter +1;
		}else {
			return [downloadedBooks count];
		}
		
		
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"iShamela.BookList";
    
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];					
	}
    
    if (self.segmentedCategoryView.selectedSegmentIndex == 0){
		
		if (indexPath.row < recordCounter) {
			
			categoryInfo = [categoryItem objectAtIndex:indexPath.row];
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentRight;
			cell.textLabel.text = categoryInfo.categoryName;
			cell.textLabel.textColor = [UIColor blackColor];
			cell.accessoryType = categoryInfo.selected ? UITableViewCellAccessoryCheckmark :UITableViewCellAccessoryNone;

		}else {
			cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor redColor];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
	}else{
		
		if (indexPath.row < recordCounter) {
			bookInfo = [downloadedBooks objectAtIndex:indexPath.row];
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentRight;
			cell.textLabel.text = bookInfo.bookName;
			cell.textLabel.textColor = [UIColor blackColor];
			cell.accessoryType = bookInfo.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
		}else {
			
			cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor redColor];
			cell.accessoryType = UITableViewCellAccessoryNone;

		}
		
	}
   	
    return cell;
}

/* 
 -(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
 
 if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
 if ([searchText length] == 0) {
 
 [categoryItem removeAllObjects];
 [categoryItem addObjectsFromArray:categoryLibaray];
 }else {
 [categoryItem removeAllObjects];
 for (int i = 0; i < [categoryLibaray count]; i++) {
 categoryInfo = [categoryLibaray objectAtIndex:i];
 NSString *booktitle = categoryInfo.categoryName;
 
 NSRange r = [booktitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
 
 if (r.location != NSNotFound) {
 [categoryItem addObject:categoryInfo];
 }
 
 }
 }
 }else {
 
 if (self.segmentedCategoryView.selectedSegmentIndex == 1) {
 
 if ([searchText length] == 0) {
 
 [autherItems removeAllObjects];
 [autherItems addObjectsFromArray:autherLibrary];
 }else {
 [autherItems removeAllObjects];
 for (int i = 0; i < [autherLibrary count]; i++) {
 bookInfo = [autherLibrary objectAtIndex:i];
 NSString *bookauther = bookInfo.bookAuther;
 
 NSRange r = [bookauther rangeOfString:searchText options:NSCaseInsensitiveSearch];
 
 if (r.location != NSNotFound) {
 [autherItems addObject:bookInfo];
 }
 
 }
 }
 }else {
 
 if ([searchText length] == 0) {
 
 [downloadedBooks removeAllObjects];
 [downloadedBooks addObjectsFromArray:[ShLibrary sharedLibrary].bookList ];
 }else {
 [downloadedBooks removeAllObjects];
 for (int i = 0; i < [[ShLibrary sharedLibrary].bookList  count]; i++) {
 bookInfo = [[ShLibrary sharedLibrary].bookList  objectAtIndex:i];
 NSString *booktitle = bookInfo.bookName;
 
 NSRange r = [booktitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
 
 if (r.location != NSNotFound) {
 [downloadedBooks addObject:bookInfo];
 }
 
 }
 }
 }
 }
 [aTableView reloadData];
 
 }
 */

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	searchCounter = 0;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"searchCounter"];
    [searchBar resignFirstResponder];
	[bookTOC removeAllObjects];
	if (segmentedCategoryView.selectedSegmentIndex == 0) {
		
		for (int i = 0; i< [categoryItem count]; i++) {
			categoryInfo = [categoryItem objectAtIndex:i];
			
			if (categoryInfo.selected) {
				for (int j = 0; j < [downloadedBooks count]; j++) {
					bookInfo = [downloadedBooks objectAtIndex:j];
					if ([categoryInfo.categoryId isEqualToString:bookInfo.bookCategory]) {
						if (searchCounter < [myString intValue]) {
                            [self searchInCategory:bookInfo.bookId SearchText:searchBar.text];
                            //NSLog(@"book id %@, search text %@",bookInfo.bookId, searchBar.text);
                        }
					}
				}
			}
		}
		
	}else {
		for (int i = 0; i < [downloadedBooks count]; i++) {
			bookInfo = [downloadedBooks objectAtIndex:i];
			if (bookInfo.selected) {
				[self searchInCategory:bookInfo.bookId SearchText:searchBar.text];
			}
		}
	}
	NSString *nibName = NULL;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		
		nibName = @"TOCviewController";
	}else {
		nibName = @"TOCviewController-iPad";
	}
	
	TOCviewController *TOCview = [[TOCviewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    [TOCview setSearchTOCItem:self.bookTOC];
	
    //TOCview.searchTOCItem = bookTOC;
	
    //TOCview.bookInfo = bookInfo; 		
	//TOCview.bookTitle = bookInfo.bookName;
	//NSLog(@"%@",bookInfo.bookId);
	[self.navigationController pushViewController:TOCview animated:YES];
	[TOCview release];
	
}

-(void) searchInCategory:(NSString *)bookID SearchText:(NSString *)searchText
{
   // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:[bookID stringByAppendingString:@".sqlite"]];
	
	//NSString *query = [NSString stringWithFormat:@"select * from t%@ where lvl < 3",bookID];
	NSString *query = [NSString stringWithFormat:@"SELECT distinct id FROM b%@ WHERE nass LIKE '%%%@%%'", bookID, searchText];
	
	[dbManager closeDB];
	
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *dbConnection= [dbManager openDb:pathToDb];
	
	const char *sql = [query UTF8String];
	
	BOOL done = NO;
    
    NSMutableArray *set1 = [[[NSMutableArray alloc] init] autorelease];
    //NSMutableSet *set2 = [[NSMutableSet alloc] init];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"searchCounter"];
    //NSLog(@"%@",myString);
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(selectstmt) == SQLITE_ROW && searchCounter < [myString intValue]) {
			
			NSString *TOCid =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			NSString *TOCQuery = [NSString stringWithFormat:@"SELECT * FROM	t%@ WHERE id <= %@ ORDER BY id DESC ",bookID, TOCid];
			NSLog(@"tocid is -->%@ and bokid is %@",TOCid,bookID);
			sqlite3_stmt *TOCstmt = NULL;
			const char *TOCsql = [TOCQuery UTF8String];
			done = NO;
			if (sqlite3_prepare_v2(dbConnection, TOCsql, -1, &TOCstmt, NULL) == SQLITE_OK) {
				while (sqlite3_step(TOCstmt) == SQLITE_ROW && done == NO) {
                    
                    //NSLog(@"%i",searchCounter);
					NSString *bTitle =[NSString stringWithUTF8String:(char *)sqlite3_column_text(TOCstmt, 0)];
					NSString *level = [NSString stringWithUTF8String:(char *)sqlite3_column_text(TOCstmt, 1)];
					NSString *subLevel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(TOCstmt, 2)];
					NSString *pageNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(TOCstmt, 3)];
					
					done = YES;
                    if (![set1 containsObject:pageNo]) {
                        [set1 addObject:pageNo];
                        TOCinfo = [[TOC alloc] initWithId:bookID Title:bTitle Level:level Sub:subLevel Id:pageNo]; 
                        
                        [bookTOC addObject:TOCinfo];
                        [TOCinfo release];
                        searchCounter++;

                    }
                    
                    NSLog(@"page number %@",pageNo);
                    done = YES;
				}
				
			}
			//done = NO;
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
	NSLog(@"%@",set1);
	//	[pool release];
	
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	searchBar.text = @"";
	//[searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	if (indexPath.row < recordCounter) {
		
	
	if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
		
		
		categoryInfo = [categoryItem objectAtIndex:indexPath.row];
		categoryInfo.selected = !categoryInfo.selected;			
		
	}else{
		
		bookInfo = [downloadedBooks objectAtIndex:indexPath.row];
		bookInfo.selected = !bookInfo.selected;
	}		
	}else {
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		
		// getting an NSString
		NSString *myString = [prefs stringForKey:@"recordCounter"];
		
		recordCounter += [myString intValue];
	}

	[aTableView reloadData];
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
