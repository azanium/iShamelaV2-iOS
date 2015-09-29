//
//  HomeViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/4/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "HomeViewController.h"
#import "Category.h"
#import "ShLibrary.h"

@implementation HomeViewController

@synthesize segmentedCategoryView, aTableView, aSearchBar;
@synthesize categoryInfo, bookInfo;// ,categoryLibrary, downloadedBooks;

- (IBAction)categorySelectionChanged:(id)sender
{
    [self.aTableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{    
   // [downloadedBooks release];
   // [categoryItem release];
   // [categoryLibaray release];
   // [categoryInfo release];
   // [bookInfo release];
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
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	if (refresh == YES) {
		
		[downloadedBooks removeAllObjects];
		[downloadedBooks addObjectsFromArray:[ShLibrary sharedLibrary].bookList ];
        //NSLog(@"in side view will appear");
        [categoryItem removeAllObjects];
        
        [self downloadCategories];
        [self.aTableView reloadData];
        
		
	}
	
	
}
-(void) viewWillDisappear:(BOOL)animated{
    
    refresh = YES;
    
}
- (void) setEditing:(BOOL)editing animated:(BOOL)animated 
{
	[super setEditing:editing animated:YES];
	[aTableView setEditing:editing animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    delegateObj =(iShamelaAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	//categoryLibaray = [[NSMutableArray alloc] init];
	categoryItem = [[NSMutableArray alloc] init];
	dbManager = [[DbManager alloc] init]; 

	[self fetchCategories];
	
	downloadedBooks = [[NSMutableArray alloc] initWithArray:[ShLibrary sharedLibrary].bookList ];
	[self downloadCategories];
	NSLog(@"%@",[ShLibrary sharedLibrary].bookCategories);
   
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"recordCounter"];
	
	recordCounter = [myString intValue];
    refresh = NO;
}

/*
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
 */
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
			
			Category *catInfo = [Category categoryWithId:categoryId catOrd:categoryOrder level:categoryLevel name:categoryName];
			
			[delegateObj.categoryLibaray addObject:catInfo];		
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
	[pool release];
	
	
	
}

-(void)downloadCategories
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
   // for (Category *c in delegateObj.categoryLibaray) {
   //     NSLog(@"%@",c.categoryId);
   // }
    
            for (int i = 0; i < [delegateObj.categoryLibaray count] ; i++) {
                
                Category *catInfo  = [delegateObj.categoryLibaray objectAtIndex:i];
                for (int j = 0; j< [downloadedBooks count]; j++) {
                    BookInfo *book = [downloadedBooks objectAtIndex:j];
				
                    if ([book.bookCategory isEqualToString:catInfo.categoryId]) {
                        NSLog(@"inside downloadlibrary");
                        [categoryItem addObject:catInfo];
                        j = [[ShLibrary sharedLibrary].bookList count];
					
                    }
                }
			
		}
    NSLog(@"%@",categoryItem);
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
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
	return YES;
}

#pragma mark -
#pragma mark Table View
/*
 -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
 return [[ShLibrary sharedLibrary].bookCategories count];        
 }
 else
 {
 return 1;
 }
 
 }
 */
/*
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 if (self.segmentedCategoryView.selectedSegmentIndex == 0) 
 {
 Category *cat = [categoryLibaray objectAtIndex:section];
 return cat.categoryName;
 }
 else
 {
 return @"";
 }
 }
 */

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
    
    if (self.segmentedCategoryView.selectedSegmentIndex == 0)
    {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
		cell.accessoryView = imageView;
		[imageView release];
		if (indexPath.row < recordCounter) {
			
			Category *category = [categoryItem objectAtIndex:indexPath.row];
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentRight;
			cell.textLabel.text = category.categoryName;
			cell.textLabel.textColor = [UIColor blackColor];
		}else {
			cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor redColor];
		}
        
	}
    else
    {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookBlue-32.png"]];
		cell.accessoryView = imageView;
		[imageView release];
		if (indexPath.row < recordCounter) {
			BookInfo *book = [downloadedBooks objectAtIndex:indexPath.row];
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentRight;
			cell.textLabel.text = book.bookName;
			cell.textLabel.textColor = [UIColor blackColor];
		}else {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
			cell.accessoryView = imageView;
			[imageView release];
			cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor redColor];
		}
        
		
		
		
    }
    
    return cell;
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
	if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
		if ([searchText length] == 0) {
			
			[categoryItem removeAllObjects];
			[categoryItem addObjectsFromArray:delegateObj.categoryLibaray];
		}else {
			[categoryItem removeAllObjects];
			for (int i = 0; i < [delegateObj.categoryLibaray count]; i++) {
				categoryInfo = [delegateObj.categoryLibaray objectAtIndex:i];
				NSString *booktitle = categoryInfo.categoryName;
				
				NSRange r = [booktitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
				
				if (r.location != NSNotFound) {
					[categoryItem addObject:categoryInfo];
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *nibName = NULL;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
			nibName = @"BookViewController";
		}else {
			nibName = @"TOCviewController";
		}
	}else {
		if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
			nibName = @"BookViewController-iPad";
		}else {
			nibName = @"TOCviewController-iPad";
		}
	}
	
	
	if (indexPath.row < recordCounter) {
		
        
        if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
            //NSString *nibName = @"BookViewController";
            NSString *isdownload = @"YES";
            BookViewController *BookView = [[BookViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
            
            self.categoryInfo = [categoryItem objectAtIndex:indexPath.row];
            [BookView setCategoryInfo:self.categoryInfo];
            //BookView.categoryInfo = categoryInfo;
            BookView.isdownloaded = isdownload;
            [self.navigationController pushViewController:BookView animated:YES];
            [BookView release];
            
        }else{
            
            //NSString *nibName = @"TOCviewController";
            
            TOCviewController *TOCview = [[TOCviewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
            self.bookInfo = [downloadedBooks objectAtIndex:indexPath.row];
            [TOCview setBookInfo:self.bookInfo];
            [TOCview setBookTitle:self.bookInfo.bookName];
            //TOCview.bookInfo = bookInfo; 		
            //TOCview.bookTitle = bookInfo.bookName;
            [self.navigationController pushViewController:TOCview animated:YES];
            [TOCview release];
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

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self deleteBooks:indexPath];
		if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
			
			[categoryItem removeObjectAtIndex:indexPath.row];
		}else {
			
			
			[downloadedBooks removeObjectAtIndex: indexPath.row];
		}
		[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];		
	}
}

-(void) deleteBooks:(NSIndexPath *)indexPath
{
	if (self.segmentedCategoryView.selectedSegmentIndex == 0) {
		
		categoryInfo = [categoryItem objectAtIndex:indexPath.row];
		
		for (int i = 0; i < [downloadedBooks count]; i++) {
			
			bookInfo = [downloadedBooks objectAtIndex:i];
			
			if ([bookInfo.bookCategory isEqualToString:categoryInfo.categoryId]) {
				
                [downloadedBooks removeObjectAtIndex:i];
				NSMutableString *filenameAZX= [[[NSMutableString alloc] initWithString:bookInfo.bookId]autorelease];
				[filenameAZX appendString:@".azx"];
				NSString *documentPath = [DbManager getUserDocumentPath];
				NSError *error;
				BOOL success = [[NSFileManager defaultManager] removeItemAtPath: [documentPath stringByAppendingPathComponent: filenameAZX] error: &error];
				
				if (!success) {
					NSLog(@"BookViewController: Delete Row: File not Found");
				}
				
				NSMutableString *filename= [[[NSMutableString alloc] initWithString:bookInfo.bookId] autorelease];
				[filename appendString:@".sqlite"];
				NSString *manifestPath = [DbManager getManifestsPath];
				success = [[NSFileManager defaultManager] removeItemAtPath: [manifestPath stringByAppendingPathComponent: filename] error: &error];
				
				if (!success) {
					NSLog(@"BookViewController: Delete Row: File not Found");
				}
				
			}
		}
		
	}else {
		
		bookInfo = [downloadedBooks objectAtIndex: indexPath.row];
		NSMutableString *filenameAZX= [[[NSMutableString alloc] initWithString:bookInfo.bookId]autorelease];
		[filenameAZX appendString:@".azx"];
		NSString *documentPath = [DbManager getUserDocumentPath];
		NSError *error;
		BOOL success = [[NSFileManager defaultManager] removeItemAtPath: [documentPath stringByAppendingPathComponent: filenameAZX] error: &error];
		
		if (!success) {
			NSLog(@"BookViewController: Delete Row: File not Found");
		}else{
            
            NSLog(@"BookViewController: Delete Row: AZX File Deleted");
        }
		
		NSMutableString *filename= [[[NSMutableString alloc] initWithString:bookInfo.bookId] autorelease];
		[filename appendString:@".sqlite"];
		NSString *manifestPath = [DbManager getManifestsPath];
		success = [[NSFileManager defaultManager] removeItemAtPath: [manifestPath stringByAppendingPathComponent: filename] error: &error];
		
		if (!success) {
			NSLog(@"BookViewController: Delete Row: File not Found");
		}else{
            
            NSLog(@"BookViewController: Delete Row: SQLITE File Deleted");
        }
        
	}
}
@end
