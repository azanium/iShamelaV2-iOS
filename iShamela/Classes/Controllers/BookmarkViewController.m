//
//  BookmarkViewController.m
//  iShamela
//
//  Created by Imran Bashir on 10/17/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "BookmarkViewController.h"


@implementation BookmarkViewController

@synthesize aTableView, aSearchBar;
#pragma mark -
#pragma mark View lifecycle



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	bookMarks = [[NSMutableArray alloc] init];
	db = [[DbManager alloc] init];
	[self fetchBookMarks];
	
	bookMarkItems = [[NSMutableArray alloc] initWithArray:bookMarks];
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"recordCounter"];
	
	recordCounter = [myString intValue];
	
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.backBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"Back"
									  style: UIBarButtonItemStyleBordered
									 target:nil
									 action:nil] autorelease];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	if (bookMarks) {
		[bookMarks removeAllObjects];
		[self fetchBookMarks];
		bookMarkItems = [[NSMutableArray alloc] initWithArray:bookMarks];
		[aTableView reloadData];
	}
	
}
- (void) setEditing:(BOOL)editing animated:(BOOL)animated 
{
	[super setEditing:editing animated:YES];
	[aTableView setEditing:editing animated:YES];
}

-(void) keyboardShown:(NSNotification *)note {
	
	/*CGRect keyboardFram;
	 [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFram];
	 CGRect tableViewFram = aTableView.frame;
	 tableViewFram.size.height -= keyboardFram.size.height-40;
	 [aTableView setFrame:tableViewFram];
	 [aSearchBar setShowsCancelButton:YES animated:YES];*/
	
}

-(void) keyboardHidden:(NSNotification *)note {
	
	/*[aTableView setFrame:self.view.bounds];*/
}

- (void)fetchBookMarks
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:@"BookMark.sqlite"];
	
	NSString *query = [NSString stringWithFormat:@"select * from main"];
	
	[db closeDB];
	
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *dbConnection= [db openDb:pathToDb];
	
	const char *sql = [query UTF8String];
	
	BOOL done = NO;
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(selectstmt) == SQLITE_ROW && !done) {
			
			NSString *bookmarkid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			NSString *bookid =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
			//NSString *bookname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
			NSString *indexname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
			NSString *indexlevel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
			NSString *indexid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
			NSString *nass = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)];
			NSString *nassid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 7)];
			NSString *part = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 8)];
			NSString *pageno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 9)];
			if ((char *)sqlite3_column_text(selectstmt, 10)!= NULL) {
                NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 10)];
                bookMark = [[BookMark alloc] bookMarkWithId:bookmarkid BookId:bookid indexName:indexname indexLevel:indexlevel indexId:indexid nass:nass nassId:nassid Part:part PageNo:pageno Description:desc];
            }else{
           // NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 10)];
			bookMark = [[BookMark alloc] bookMarkWithId:bookmarkid BookId:bookid indexName:indexname indexLevel:indexlevel 
												indexId:indexid nass:nass nassId:nassid Part:part PageNo:pageno Description:@""];
            }
			
			[bookMarks addObject:bookMark];
			[bookMark release];
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
	
	[pool release];
	
}

-(void) deleteBookMark:(NSIndexPath *)indexPath
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:@"BookMark.sqlite"];
	
	NSLog(@"%@",pathToDb);
	
	bookMark = [bookMarkItems objectAtIndex:indexPath.row];
	
	NSString *query = [NSString stringWithFormat:
					   @"DELETE from main where id = %@", bookMark.bookMarkId];
	
	NSLog(@"%@",query);
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *database;
	
	if(sqlite3_open([pathToDb UTF8String], &database) == SQLITE_OK) {
		
		sqlite3 *dbConnection= [db openDb:pathToDb];
		
		const char *sql = [query UTF8String];
		
		if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			NSLog(@"record Deleted");
			
			if(SQLITE_DONE != sqlite3_step(selectstmt))
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			else
				//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
				NSLog(@"record Deleted");
			
			//Reset the add statement.
			sqlite3_reset(selectstmt);
		}else {
			NSLog(@"DBManager:deleteRecords: Failed to prepare SQlite3 DB...");
		}
		
		sqlite3_finalize(selectstmt);
	}else {
		NSLog(@"DBManager:openDatabse: Failed to Open SQlite3 DB...");
	}
	
	[pool release];
	
	
	
}
/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	if (recordCounter < [bookMarkItems count]) {
		return recordCounter +1;
	}else {
		return [bookMarkItems count];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if (indexPath.row < recordCounter) {
		
		
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmarkBlue-32.png"]];
		cell.accessoryView = imageView;
		[imageView release];
		
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
		cell.textLabel.textAlignment = UITextAlignmentRight;
		cell.textLabel.textColor = [UIColor blackColor];
		// Configure the cell...
		
		bookMark = [bookMarkItems objectAtIndex:indexPath.row];
		cell.textLabel.text = bookMark.indexName;
        
       // cell.detailTextLabel.textAlignment = UITextAlignmentRight;
		//cell.detailTextLabel.textColor = [UIColor blackColor];
        //cell.detailTextLabel.text = bookMark.description;
		
	}else {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
		cell.accessoryView = imageView;
		[imageView release];
		
		cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor redColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		[self deleteBookMark:indexPath];
		[bookMarkItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


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
	NSString *nibName = NULL;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		nibName = @"ContentViewController";
	}else {
		nibName = @"ContentViewController-iPad";
	}
	
	if (indexPath.row < recordCounter) {
		
		
		ContentViewController *ContentView = [[ContentViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
		bookMark = [bookMarkItems objectAtIndex:indexPath.row];
		ContentView.bookTitle = bookMark.indexName;
		ContentView.bookMark = bookMark; 		
		ContentView.isBookMark = @"YES";
		
		ContentView.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:ContentView animated:YES];
        [ContentView release];
	}else {
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		
		// getting an NSString
		NSString *myString = [prefs stringForKey:@"recordCounter"];
		
		recordCounter += [myString intValue];
		[aTableView reloadData];
		
	}
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
}
/*
 -(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (tableView != self.searchDisplayController.searchResultsTableView)
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 Book *book = [bookList objectAtIndex: indexPath.row];
 
 NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentPath = [searchPaths objectAtIndex: 0];
 NSError *error;
 BOOL success = [[NSFileManager defaultManager] removeItemAtPath: [documentPath stringByAppendingPathComponent: book.fileName] error: &error];
 
 if (!success) {
 NSLog(@"BookViewController: Delete Row: File not Found");
 }
 
 [bookList removeObjectAtIndex: indexPath.row];
 
 [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];		
 }
 }
 }
 */
#pragma mark -
#pragma mark UISearchBar delegate

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	
	if ([searchText length] == 0) {
		
		[bookMarkItems removeAllObjects];
		[bookMarkItems addObjectsFromArray:bookMarks];
	}else {
		
		[bookMarkItems removeAllObjects];
		
		for (int i = 0; i < [bookMarks count]; i++) {
			
			bookMark = [bookMarks objectAtIndex:i];
			
			NSString *indexName = bookMark.indexName;
			
			
			NSRange r = [indexName rangeOfString:searchText options:NSCaseInsensitiveSearch];
			
			if (r.location != NSNotFound) {
				[bookMarkItems addObject:bookMark];
			}
		}
	}
	[aTableView reloadData];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

