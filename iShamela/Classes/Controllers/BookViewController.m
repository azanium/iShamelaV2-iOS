//
//  BookViewController.m
//  iShamela
//
//  Created by Imran Bashir on 10/21/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "BookViewController.h"


@implementation BookViewController

@synthesize aTableView, aSearchBar;

@synthesize categoryInfo, isdownloaded;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	delegateObj =(iShamelaAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	self.navigationItem.title = categoryInfo.categoryName;
	
	bookLibrary = [[NSMutableArray alloc] init];
	dbManager = [[DbManager alloc] init]; 
	
	[self fetchLibrary];
	
	bookItems = [[NSMutableArray alloc] initWithArray:bookLibrary];
	downloadedBooks = [[NSMutableArray alloc] initWithArray:[ShLibrary sharedLibrary].bookList ];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"recordCounter"];
	
	recordCounter = [myString intValue];
	
}

-(void) requestDownload
{
	NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
	
	if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];	
	}
	//failed = NO;
	[networkQueue reset];
	//[networkQueue setDownloadProgressDelegate:progressIndicator];
	[networkQueue setRequestDidFinishSelector:@selector(bookFetchComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(bookFetchFailed:)];
	//[networkQueue setShowAccurateProgress:[accurateProgress isOn]];
	[networkQueue setDelegate:self];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	NSMutableString *pathToDownload = [[[NSMutableString alloc] init] autorelease];
	
	for (int i = 0; i < [delegateObj.DownloadBooks count]; i++) {
		NSMutableDictionary *dic = [delegateObj.DownloadBooks objectAtIndex:i];
		[delegateObj.DownloadBooks removeObjectAtIndex:i];
		[pathToDownload appendString:[dic objectForKey:@"URL"]];
		[pathToDownload appendString:[dic objectForKey:@"bookId"]];
		[pathToDownload appendString:@".azx"];
		
		[pathToDb appendString:[DbManager getUserDocumentPath]];
		[pathToDb appendString:@"/"];
		[pathToDb appendString:[dic objectForKey:@"bookId"]];
		[pathToDb appendString:@".azx"];
		
		NSLog(@"%@",pathToDownload);
		NSLog(@"%@",pathToDb);
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:pathToDownload]];
		[request setDownloadDestinationPath:pathToDb];
		[networkQueue addOperation:request];
		
	}
	
	[networkQueue go];
	
	[pool release];
	
}

-(void)bookFetchFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Selected book download is failed, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
	[alert show];
	[alert release];
	
	
}
-(void)bookFetchComplete:(ASIHTTPRequest *)request
{
	[[ShLibrary sharedLibrary] reloadBooks];
	[downloadedBooks removeAllObjects];
	downloadedBooks = [[NSMutableArray alloc] initWithArray:[ShLibrary sharedLibrary].bookList ];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Selected book download is complete" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
	[alert show];
	[alert release];
	[aTableView reloadData];
	
}


-(void)fetchLibrary
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if ([self.isdownloaded isEqualToString:@"YES"]) {
		for (int i = 0; i< [[ShLibrary sharedLibrary].bookList count]; i++) {
			BookInfo *book = [[ShLibrary sharedLibrary].bookList objectAtIndex:i];
			
			if ([book.bookCategory isEqualToString:categoryInfo.categoryId]) {
				[bookLibrary addObject:book];
			}
		}
		
	}else {
		
		
		NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
		
		[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
		[pathToDb appendString:@"library.sqlite"];
		
		NSString *query = [NSString stringWithFormat:@"select bookId, bookTitle, bookDescription, bookCategory, Auth from library where bookCategory = '%@'",categoryInfo.categoryId];
		
		NSLog(@"%@",query);
		[dbManager closeDB];
		
		sqlite3_stmt *selectstmt = NULL;
		
		sqlite3 *dbConnection= [dbManager openDb:pathToDb];
		
		const char *sql = [query UTF8String];
		BOOL done = NO;
		if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW && !done) {
				
				NSString *bookId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
				NSString *bookTitle =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				NSString *bookDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				NSString *bookCategory = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
				NSString *auth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
				
				
				bookInfo = [BookInfo bookWithTitle:bookId name:bookTitle detail:bookDescription category:bookCategory auther:auth];
				
				[bookLibrary addObject:bookInfo];
			}
		} else {
			NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
		}
		
		sqlite3_finalize(selectstmt);
	}
	[pool release];
	
	
	
}
-(void) keyboardShow:(NSNotification *)note {
	
	CGRect keyboardFram;
	[[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFram];
	CGRect tableViewFram = aTableView.frame;
	tableViewFram.size.height -= keyboardFram.size.height-40;
	[aTableView setFrame:tableViewFram];
	
	[aSearchBar setShowsCancelButton:YES animated:YES];
	
}

-(void) keyboardHide:(NSNotification *)note {
	
	CGRect keyboardFram;
	[[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFram];
	CGRect tableViewFram = aTableView.frame;
	tableViewFram.size.height += keyboardFram.size.height-40;
	[aTableView setFrame:tableViewFram];
	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationItem.backBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"Back"
									  style: UIBarButtonItemStyleBordered
									 target:nil
									 action:nil] autorelease];
	
}

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
    
	if (recordCounter < [bookItems count]) {
		return recordCounter +1;
	}else {
		return [bookItems count];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	if (indexPath.row < recordCounter) {
		
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookBlue-32.png"]];
		cell.accessoryView = imageView;
		[imageView release];
		
		bookInfo = [bookItems objectAtIndex:indexPath.row];
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.textLabel.textAlignment = UITextAlignmentRight;
		cell.textLabel.textColor = [UIColor blackColor];
		
		for (int i = 0; i< [downloadedBooks count]; i++) {
			
			BookInfo *book =  [downloadedBooks objectAtIndex:i];
			
			if ([book.bookName isEqualToString: bookInfo.bookName]) {
				cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
				break;
			}
		}
		
		cell.textLabel.text = bookInfo.bookName;
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

#pragma mark -
#pragma mark UISearchBar delegate

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	
	if ([searchText length] == 0) {
		
		[bookItems removeAllObjects];
		[bookItems addObjectsFromArray:bookLibrary];
	}else {
		
		[bookItems removeAllObjects];
		
		for (int i = 0; i < [bookLibrary count]; i++) {
			
			bookInfo = [bookLibrary objectAtIndex:i];
			
			NSString *booktitle = bookInfo.bookName;
			
			
			NSRange r = [booktitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
			
			if (r.location != NSNotFound) {
				[bookItems addObject:bookInfo];
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
	[searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
	
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


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
	if (indexPath.row < recordCounter) {
		
		
		downloaded = FALSE;
		inQueue = FALSE;
		
		bookInfo = [bookItems objectAtIndex:indexPath.row];
		
		for (int i = 0; i< [downloadedBooks count]; i++) {
			
			BookInfo *book =  [downloadedBooks objectAtIndex:i];
			
			if ([book.bookName isEqualToString: bookInfo.bookName]) {
				downloaded = TRUE;
				break;
				
			}
		}
		NSString *nibName = NULL;
		
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		{
			nibName = @"TOCviewController";
		}else {
			nibName = @"TOCviewController-iPad";
		}
		if (downloaded) {
			
			TOCviewController *TOCview = [[TOCviewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
			
			TOCview.bookInfo = bookInfo; 		
			TOCview.bookTitle = bookInfo.bookName;
			NSLog(@"%@",bookInfo.bookId);
			[self.navigationController pushViewController:TOCview animated:YES];
			[TOCview release];
		}else{
			NSMutableDictionary *dic;
			for (int i = 0; i < [delegateObj.DownloadBooks count]; i++) {
				dic = [delegateObj.DownloadBooks objectAtIndex:i];
				NSString *bookId = [dic objectForKey:@"bookId"];
				if ([bookInfo.bookId isEqualToString:bookId]) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Selected book is already in download queue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
					[alert show];
					[alert release];
					inQueue = TRUE;
				}
			}
			
			if (!inQueue) 
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Selected book is not in your local library, Do you want to Download it ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];	
				[alert show];
				[alert release];
				
				
			}	
		}
	}else {
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		
		// getting an NSString
		NSString *myString = [prefs stringForKey:@"recordCounter"];
		
		recordCounter += [myString intValue];
		[aTableView reloadData];
		
	}
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	
}
#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		// Yes, do something
	}
	else if (buttonIndex == 1)
	{
		// No
		NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
		[dic setObject:bookInfo.bookId forKey:@"bookId"];
		[dic setObject:bookInfo.bookCategory forKey:@"bookCategory"];
		[dic setObject:@"http://ishamela.com/books/" forKey:@"URL"];
		[dic setObject:@"yes" forKey:@"inQueue"];
		[delegateObj.DownloadBooks addObject:dic];
		[self requestDownload];
	}
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
	self.aTableView = nil;
	
}


- (void)dealloc {
    [networkQueue release];
   // [categoryInfo release];
   // [bookLibrary release];
//	[dbManager release]; 	
 //   [bookItems release];
//	[downloadedBooks release];     
    [super dealloc];
}


@end

