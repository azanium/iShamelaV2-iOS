//
//  DownloadViewController.m
//  iShamela
//
//  Created by Imran Bashir on 10/25/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "DownloadViewController.h"


@implementation DownloadViewController
@synthesize segmentedCategoryView, aTableView, aSearchBar;
//@synthesize delegateObj;

#pragma mark -
#pragma mark View lifecycle

- (IBAction)categorySelectionChanged:(id)sender
{
    [self.aTableView reloadData];
	NSLog(@"inside change");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	downloading = FALSE;
	isCategory = FALSE;
	inQueue = TRUE;
	delegateObj =(iShamelaAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	
	bookLibrary = [[NSMutableArray alloc] init];
	categoryLibaray = [[NSMutableArray alloc] init];
	dbManager = [[DbManager alloc] init]; 
    progressBar = [[NSMutableArray alloc] init];
	
	[self fetchCategories];
	
	[self fetchLibrary];
	
	downloadedBooks = [[NSMutableArray alloc] initWithArray:[ShLibrary sharedLibrary].bookList ];
	bookItems = [[NSMutableArray alloc] initWithArray:bookLibrary];
	categoryItem = [[NSMutableArray alloc] initWithArray:categoryLibaray];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"recordCounter"];
	
	recordCounter = [myString intValue];
    downloadCounter = 0;
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

-(void) requestDownload
{
	NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
	
	if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];	
	}
	//failed = NO;
	//[networkQueue reset];
	//[networkQueue setDownloadProgressDelegate:progressIndicator];
	[networkQueue setRequestDidFinishSelector:@selector(bookFetchComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(bookFetchFailed:)];
	[networkQueue setShowAccurateProgress:YES];
	[networkQueue setDelegate:self];
	
	//NSMutableString *pathToDb = [[NSMutableString alloc] init];
	//NSMutableString *pathToDownload = [[NSMutableString alloc] init];
	
	for (int i = 0; i < [delegateObj.DownloadBooks count]; i++) {
		NSMutableDictionary *dic = [delegateObj.DownloadBooks objectAtIndex:i];
		//[delegateObj.DownloadBooks removeObjectAtIndex:i];
		
		NSMutableString *pathToDb = [[NSMutableString alloc] init];
		NSMutableString *pathToDownload = [[NSMutableString alloc] init];
		
		[pathToDownload appendString:[dic objectForKey:@"URL"]];
		[pathToDownload appendString:[dic objectForKey:@"bookId"]];
		[pathToDownload appendString:@".azx"];
		
		[pathToDb appendString:[DbManager getUserDocumentPath]];
		[pathToDb appendString:@"/"];
		[pathToDb appendString:[dic objectForKey:@"bookId"]];
		[pathToDb appendString:@".azx"];
		
		//NSLog(@"%@\n",pathToDownload);
		//NSLog(@"%@",pathToDb);
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:pathToDownload]];
		[request setDownloadDestinationPath:pathToDb];
        [request setDownloadProgressDelegate:[progressBar objectAtIndex:progressBarIndex]];
		[networkQueue addOperation:request];
		[pathToDownload release];
		[pathToDb release];
        downloadCounter++;
		
	}
	[delegateObj.DownloadBooks removeAllObjects];
	if (!downloading) {
		[networkQueue go];
		downloading = TRUE;
	}
	[pool release];
	
}

-(void)bookFetchFailed:(ASIHTTPRequest *)request
{
	downloadCounter--;
    if (downloadCounter == 0) {
        
        [[ShLibrary sharedLibrary] reloadBooks];
        [downloadedBooks removeAllObjects];
        [downloadedBooks addObjectsFromArray:[ShLibrary sharedLibrary].bookList ];
        NSLog(@"in down %d",[[ShLibrary sharedLibrary].bookList count]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Selected books downloading is failed, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
        [alert show];
        [alert release];
        [delegateObj.DownloadBooks removeAllObjects];
        
	}
}
-(void)bookFetchComplete:(ASIHTTPRequest *)request
{
	downloadCounter--;
    if(downloadCounter == 0){
        [[ShLibrary sharedLibrary] reloadBooks];
        [downloadedBooks removeAllObjects];
        [downloadedBooks addObjectsFromArray:[ShLibrary sharedLibrary].bookList ];
        NSLog(@"in down %d",[[ShLibrary sharedLibrary].bookList count]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Selected books downloading is complete" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
        [alert show];
        [alert release];
        [aTableView reloadData];
        downloading = FALSE;
    }
	
}

-(void)fetchLibrary
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:@"library.sqlite"];
	
	NSString *query = [NSString stringWithFormat:@"select bookId, bookTitle, bookDescription, bookCategory, Auth from library"];
	
	//NSLog(@"%@",pathToDb);
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
            
            progress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 20, 200, 10)];
            [progressBar addObject:progress];
            [progress release];
            
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
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
			
			categoryInfo = [Category categoryWithId:categoryId catOrd:categoryOrder level:categoryLevel name:categoryName];
			
			[categoryLibaray addObject:categoryInfo];		
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	if (self.segmentedCategoryView.selectedSegmentIndex == 0 || self.segmentedCategoryView.selectedSegmentIndex ==1)
    {
		if (recordCounter < [categoryItem count]) {
			return recordCounter +1;
		}else {
			return [categoryItem count];
		}
		
	}else{
        if (recordCounter < [bookItems count]) {
			return recordCounter +1;
		}else {
			return [bookItems count];
		}
		
    }
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"iShamela.BookList";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.row < recordCounter) {
		
        if (self.segmentedCategoryView.selectedSegmentIndex == 0 || self.segmentedCategoryView.selectedSegmentIndex == 1)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            cell.accessoryView = imageView;
            [imageView release];
            
            categoryInfo = [categoryItem objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textAlignment = UITextAlignmentRight;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = categoryInfo.categoryName;
            
        }
        else
        {
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
            //[cell addSubview:[progressBar objectAtIndex:indexPath.row]];
        }
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
    progressBarIndex = indexPath.row;
	if (indexPath.row < recordCounter) {
		
        
        NSString *nibName = NULL;
        if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Are you sure you want to Download whole category ?" delegate:self cancelButtonTitle:@"NO"     otherButtonTitles:@"YES",nil];	
            [alert show];
            [alert release];
            
            
            isCategory = TRUE;
            categoryInfo = [categoryItem objectAtIndex:indexPath.row];
            
            
        }else {
            
            if (self.segmentedCategoryView.selectedSegmentIndex == 1) {
                
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                {
                    nibName = @"BookViewController";
                }else {
                    nibName = @"BookViewController-iPad";
                    
                }
                
                NSString *isdownload = @"NO";
                BookViewController *BookView = [[BookViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
                
                categoryInfo = [categoryItem objectAtIndex:indexPath.row];
                
                BookView.categoryInfo = categoryInfo;
                BookView.isdownloaded = isdownload;
                [self.navigationController pushViewController:BookView animated:YES];
                [BookView release];
                
            }else{
                
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
                if (downloaded) {
                    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                    {
                        nibName = @"TOCviewController";
                    }else {
                        nibName = @"TOCviewController-iPad";
                        
                    }
                    
                    
                    
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
                            [self requestDownload];
                        }
                    }
                    
                    if (!inQueue) 
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Selected book is not in your local library, Do you want to Download it ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];	
                        [alert show];
                        [alert release];
                        
                        
                    }	
                }
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
		if (!inQueue) {
			NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
			[dic setObject:bookInfo.bookId forKey:@"bookId"];
			[dic setObject:bookInfo.bookCategory forKey:@"bookCategory"];
			[dic setObject:@"http://ishamela.com/books/" forKey:@"URL"];
			[dic setObject:@"yes" forKey:@"inQueue"];
			[delegateObj.DownloadBooks addObject:dic];
			NSLog(@"%@",delegateObj.DownloadBooks);
			[self requestDownload];
			
		}else {
			if (isCategory) {
				for (int i=0; i< [bookItems count]; i++) {
					downloaded = FALSE;
					bookInfo = [bookItems objectAtIndex:i];
					if ([categoryInfo.categoryId isEqualToString:bookInfo.bookCategory]) {
						
						for (int j=0; j<[downloadedBooks count]; j++) {
							BookInfo *book =  [downloadedBooks objectAtIndex:j];
							
							if ([book.bookName isEqualToString: bookInfo.bookName]) {
								downloaded = TRUE;
							}	
						}
						if (!downloaded) {
							
							
							NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
							[dic setObject:bookInfo.bookId forKey:@"bookId"];
							[dic setObject:bookInfo.bookCategory forKey:@"bookCategory"];
							[dic setObject:@"http://ishamela.com/books/" forKey:@"URL"];
							[dic setObject:@"yes" forKey:@"inQueue"];
							[delegateObj.DownloadBooks addObject:dic];
						}
					}
				}
				NSLog(@"%@",delegateObj.DownloadBooks);
				[self requestDownload];
				isCategory = FALSE;	
			}
		}
		
		
		
	}
}

#pragma mark -
#pragma mark UISearchBar delegate
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
	if (self.segmentedCategoryView.selectedSegmentIndex == 0 || self.segmentedCategoryView.selectedSegmentIndex == 1) {
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
	}
	[aTableView reloadData];
	
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	[searchBar resignFirstResponder];
	
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	searchBar.text = @"";
	//[searchBar setShowsCancelButton:NO animated:YES];
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
	self.aTableView = nil;
    self.segmentedCategoryView = nil;
	
	
}


- (void)dealloc {
    [downloadedBooks release];
	[bookItems release];
	[categoryItem release];
	[bookLibrary release];
	[categoryLibaray release];
    [super dealloc];
}


@end

