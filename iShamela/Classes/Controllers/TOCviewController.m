//
//  TOCviewController.m
//  iShamela
//
//  Created by Imran Bashir on 10/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "TOCviewController.h"


@implementation TOCviewController

@synthesize bookInfo,TOCinfo, aTableView, aSearchBar, bookTitle,searchTOCItem, TOCItems;
#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationItem.backBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"Back"
									  style: UIBarButtonItemStyleBordered
									 target:nil
									 action:nil] autorelease];
	
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	db = [[DbManager alloc] init];
	bookTOC = [[NSMutableArray alloc] init];
	if (!searchTOCItem) {
		[self.navigationItem setTitle:bookTitle];
		//self.navigationItem.title = bookTitle;
		[self fetchBookTOC:self.bookInfo.bookId];
		TOCItems = [[NSMutableArray alloc] initWithArray:bookTOC];
		
	}else {
		
		TOCItems = [[NSMutableArray alloc] initWithArray:searchTOCItem];
        // for (int i = 0; i < [TOCItems count]; i++) {
        //     TOC *startTOC = [TOCItems objectAtIndex:i];
        //     NSLog(@" indexid is --> %@",startTOC.indexId);
        // }
    }
	
	
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *myString = [prefs stringForKey:@"recordCounter"];
	
	recordCounter = [myString intValue];
	
}
- (void) fetchSearched
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray *manifests = [DbManager fetchAllManifests];
	
    if ([manifests count] > 0)
    {
        //[bookTOC removeAllObjects];
		
        for (NSString *manifest in manifests)
        {
			NSLog(@"%@",manifest);
		}
	}
	
	[pool release];
	
}
- (void) fetchBookTOC:(NSString *)bookID
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:[bookID stringByAppendingString:@".sqlite"]];
	
	NSString *query = [NSString stringWithFormat:@"select tit,lvl,sub,id from t%@ where lvl < 3 order by id",bookID];
	
	[db closeDB];
	
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *dbConnection= [db openDb:pathToDb];
	
	const char *sql = [query UTF8String];
	
	BOOL done = NO;
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(selectstmt) == SQLITE_ROW && !done) {
			
			NSString *bTitle =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			NSString *level = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
			NSString *subLevel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
			NSString *pageNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
			
			TOCinfo = [[TOC alloc] initWithId:bookID Title:bTitle Level:level Sub:subLevel Id:pageNo]; 
			
			[bookTOC addObject:TOCinfo];
			[TOCinfo release];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
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
	
    if (recordCounter < [TOCItems count]) {
		return recordCounter +1;
	}else {
		return [TOCItems count];
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
		
		
		TOCinfo = [TOCItems objectAtIndex:indexPath.row];
		if ([TOCinfo.indexLevel isEqualToString:@"2"]) {
			
			cell.textLabel.font = [UIFont italicSystemFontOfSize:16];
			cell.textLabel.textAlignment = UITextAlignmentRight;
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.text = TOCinfo.indexTitle;
		}else {
			cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
			cell.textLabel.textAlignment = UITextAlignmentRight;
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.text = TOCinfo.indexTitle;
			
		}
	}else {
		cell.textLabel.text = NSLocalizedString(@"More", @"More Table Rows");
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor redColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    // Configure the cell...
    
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

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
	if ([searchText length] == 0) {
		
		[TOCItems removeAllObjects];
		if (searchTOCItem) {
			[TOCItems addObjectsFromArray:searchTOCItem];
		}else {
			
			[TOCItems addObjectsFromArray:bookTOC];
		}
	}else {
		[TOCItems removeAllObjects];
		if (searchTOCItem) {
			for (int i = 0; i < [searchTOCItem count]; i++) {
				TOCinfo = [searchTOCItem objectAtIndex:i];
				NSString *TOCTitle = TOCinfo.indexTitle;
				
				NSRange r = [TOCTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
				
				if (r.location != NSNotFound) {
					[TOCItems addObject:TOCinfo];
				}
				
			}
			
		}else {
			
			for (int i = 0; i < [bookTOC count]; i++) {
				TOCinfo = [bookTOC objectAtIndex:i];
				NSString *TOCTitle = TOCinfo.indexTitle;
				
				NSRange r = [TOCTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
				
				if (r.location != NSNotFound) {
					[TOCItems addObject:TOCinfo];
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

- (void)findBookIds:(NSInteger)index StartID:(NSString **)startId EndID:(NSString **)endId
{
	//	TOC *endTOC = nil;
	TOC *startTOC = [TOCItems objectAtIndex:index];
	//	int level = [startTOC.indexLevel intValue];
	
	*startId = startTOC.indexId;
	NSString *bookId = startTOC.bookId;
    NSLog(@"start book id is %@",bookId);
    int i = 0;
    
	if (index >= [TOCItems count] - 1)
	{
		*endId = startTOC.indexId;
	}
	else {
		
		for (i = 0; i < [TOCItems count]; i++) {
            TOC *toc = [TOCItems objectAtIndex:i];
            NSLog(@"book id %@ index is %d",toc.bookId,i);
            if (![toc.bookId isEqualToString:bookId]) {
                break;
            }
        }
        if (i == 0) {
            
            *endId = startTOC.indexId;
        }else{
            if (i < [TOCItems count]) {
                TOC *toc = [TOCItems objectAtIndex:i-1];
                *endId = toc.indexId;
            }else{
                TOC * toc = [TOCItems objectAtIndex:[TOCItems count]-1];
                *endId = toc.indexId;
            }
        }
		/*if ((index+1) < ([bookTOC count]-1)) {
		 
		 
		 for (int i = index + 1; i < [bookTOC count] - 1; i++)
		 {
		 TOC *toc = [bookTOC objectAtIndex:i];
		 
		 if ([toc.indexLevel intValue] <= level)
		 {
		 endTOC = toc;
		 break;
		 }
		 endTOC = toc;
		 }
		 }else {
		 
		 TOC *index1 = [bookTOC objectAtIndex:index];
		 TOC *index2 = [bookTOC objectAtIndex:index+1];
		 
		 if (((index+1) == ([bookTOC count]-1)) && ((index1.indexId) < (index2.indexId))) {
		 TOC *toc = [bookTOC objectAtIndex:index+1];
		 endTOC = toc;
		 }else {
		 TOC *toc = [bookTOC objectAtIndex:index];
		 endTOC = toc;
		 }
		 
		 }
		 
		 
		 NSLog(@"endTOC %i",endTOC.indexId);
		 *endId = endTOC.indexId;
		 */
	}
	
	
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   	
	NSString *startId;
	NSString *endId;
	
	[self findBookIds:indexPath.row StartID:&startId EndID:&endId];
	
	NSString *nibName = NULL;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		nibName = @"ContentViewController";
	}else {
		nibName = @"ContentViewController-iPad";
	}
	
	if (indexPath.row < recordCounter) {
		
		
		ContentViewController *ContentView = [[ContentViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
		TOCinfo = [TOCItems objectAtIndex:indexPath.row];
		
		ContentView.bookTitle = TOCinfo.indexTitle;
		ContentView.startID = startId;
		ContentView.endID = endId;
		ContentView.TOCinfo = TOCinfo;
		ContentView.isBookMark = @"NO";
        ContentView.navigationItem.title = TOCinfo.indexTitle;
		
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
	
	//[db release];
	//[bookInfo release];
	//[TOCinfo release];
	
    //[bookTOC release];
	//[TOCItems release];
	//[bookTitle release];
	//[searchTOCItem release];
    
    [super dealloc];
}


@end

