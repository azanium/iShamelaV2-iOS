//
//  ContentViewController.m
//  iShamela
//
//  Created by Imran Bashir on 10/16/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "ContentViewController.h"

//@interface UIAlertView (SPI)
//- (void) addTextFieldWithValue:(NSString *) value label:(NSString *) label;
//@end

@implementation ContentViewController


@synthesize bookTitle,startID, endID, TOCinfo, pageIndex, isBookMark, bookMark;

@synthesize textView, next, previous, pager;



#pragma mark -
#pragma mark Translator


- (void) translator:(Translator *)sender ConnectionError:(NSError *)error
{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:NSLocalizedString(@"Translate Connection Error", @"Translator Conection Error") 
												   delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK Alert Button") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) translator:(Translator *)sender Failed:(NSString *)message
{ 
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:NSLocalizedString(@"Translate Failed HTTP:200", @"Translator error 200") 
												   delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK Alert Button") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) translator:(Translator *)sender didFinishWithText:(NSString *)result
{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Translation", @"Translation")
												  message:@"\n\n\n\n\n"
												 delegate:self
										cancelButtonTitle:NSLocalizedString(@"OK", @"OK Alert Button")
										otherButtonTitles:nil];
	//alert.textView.text = result;
	alert.message = result;
	[alert show];
	[alert release];
	
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
	
	
	//UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //[self.view addGestureRecognizer:gr];
    //[gr release];
	
	UIMenuController *menuController = [UIMenuController sharedMenuController];
	
	//UIMenuItem *translateItem = [[UIMenuItem alloc] initWithTitle:@"Translate" action:@selector(translateClicked:)];
	UIMenuItem *twitteItem = [[UIMenuItem alloc] initWithTitle:@"Question" action:@selector(twitteClicked:)];
	
	[menuController setMenuItems:[NSArray arrayWithObjects: twitteItem,nil]];
//	[menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
	[menuController setMenuVisible:YES animated:YES];
	
	
	 if ([self.isBookMark isEqualToString:@"YES"]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBookmark)] autorelease];
       //  [self fetchBookMarked];
       //  [self prepareToolbars];
        
    }else{
        
        UIImage *buttonImage = [UIImage imageNamed:@"bookmarkStar-32.png"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setImage:buttonImage forState:UIControlStateNormal];
        aButton.frame = CGRectMake(260.0, 02.0, buttonImage.size.width, buttonImage.size.height);
        UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
        [aButton addTarget:self action:@selector(bookMarkClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = aBarButtonItem;
        [aBarButtonItem release];
        
    }
	//[translateItem release];
	[twitteItem release];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	pageIndex = 0;
	
	
    contents = [[NSMutableArray alloc] init];
    db =[[DbManager alloc] init];
	
	translator = [[Translator alloc] init];
	translator.delegate = self;
	if ([self.isBookMark isEqualToString:@"YES"]) {
		[self fetchBookMarked];
	}else {
		[self fetchBookTOC:TOCinfo.bookId];
	}

	
	[self prepareToolbars];
    
//    [textView setScrollsToTop:YES];

}

-(void) fetchBookMarked{
	//if (!contents) {
        
    //    contents = [[NSMutableArray alloc] init];
    //}else{
    //    [contents removeAllObjects];
   // }
	
	BookContent *bookContent = [[BookContent alloc] bookWithId:bookMark.bookId Verse:bookMark.nass VerseID:bookMark.nassId Part:bookMark.part Page:bookMark.pageNo]; 
	
	[contents addObject:bookContent];
	[bookContent release];
	
}

- (void)insertBookMark:(NSString *) bookMarkTitle
{
	NSAutoreleasePool *pool = [[[NSAutoreleasePool alloc] init] autorelease];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:@"BookMark.sqlite"];
	
	NSLog(@"%@",pathToDb);
	
	BookContent *content = [contents objectAtIndex:pageIndex];
	
	NSString *query = [NSString stringWithFormat:
					   @"INSERT INTO main (bookId,indexName,indexLevel,indexId,nass,nassId,part,pageNo) VALUES(?,?,?,?,?,?,?,?)"];
	
	NSLog(@"%@",query);
	NSLog(@"%i",pageIndex);
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *database;
	
	if(sqlite3_open([pathToDb UTF8String], &database) == SQLITE_OK) {
		
		sqlite3 *dbConnection= [db openDb:pathToDb];
		
		const char *sql = [query UTF8String];
		
		if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			NSLog(@"record inserted");
			sqlite3_bind_text(selectstmt, 1, [TOCinfo.bookId UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 2, [bookMarkTitle UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 3, [TOCinfo.indexLevel UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 4, [TOCinfo.indexId UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 5, [content.verse UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 6, [content.verseID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 7, [content.part UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 8, [content.page UTF8String], -1, SQLITE_TRANSIENT);
			
			
			
			if(SQLITE_DONE != sqlite3_step(selectstmt))
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			else
				//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
				NSLog(@"record inserted");
			
			//Reset the add statement.
			sqlite3_reset(selectstmt);
			
		} else {
			NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
		}
		
		sqlite3_finalize(selectstmt);
	}else {
		NSLog(@"DBManager:openDatabse: Failed to Open SQlite3 DB...");
	}

	[pool release];
	
}
-(void) editBookmark{
    NSMutableDictionary *bookmarkName = [[[NSMutableDictionary alloc] init] autorelease];
    [bookmarkName setObject:bookMark.bookMarkId forKey:@"bookMarkId"];
    [bookmarkName setObject:bookMark.indexName forKey:@"bookmarkTitle"];
    [bookmarkName setObject:bookMark.description forKey:@"description"];
    
    NSString *nibName = NULL;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		nibName = @"BookmarkNameController";
	}else {
		nibName = @"BookmarkNameController-iPad";
	}
    
    BookmarkNameController *markName = [[BookmarkNameController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    markName.bookMark = bookmarkName;
    markName.editBookMark = @"YES";
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:markName];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
    
    
}

- (void) bookMarkClicked:(id) sender {
    // called when Item clicked in menu
	/*
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"BookMark"  message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil] autorelease];
	UITextView *myText = [[UITextView alloc] initWithFrame:CGRectMake(12.0, 40.0, 260.0, 60.0)];
	
	myText.text =TOCinfo.indexTitle;
	myText.font = [UIFont boldSystemFontOfSize:14];
	myText.keyboardAppearance = UIKeyboardAppearanceAlert;
	[myText setBackgroundColor:[UIColor whiteColor]];
	myText.tag = 100;

	[alert addSubview:myText];
	[myText becomeFirstResponder];
	[myText release];
	[alert show];
	
	//[self insertBookMark];
*/
    BookContent *content = [contents objectAtIndex:pageIndex];
    
    NSMutableDictionary *bookmarkName = [[[NSMutableDictionary alloc] init] autorelease];
    [bookmarkName setObject:TOCinfo.indexTitle forKey:@"bookmarkTitle"];
    [bookmarkName setObject:TOCinfo.bookId forKey:@"bookId"];
    [bookmarkName setObject:TOCinfo.indexLevel forKey:@"indexLevel"];
    [bookmarkName setObject:TOCinfo.indexId forKey:@"indexId"];
    [bookmarkName setObject:content.verse forKey:@"verse"];
    [bookmarkName setObject:content.verseID forKey:@"verseId"];
    [bookmarkName setObject:content.part forKey:@"part"];
    [bookmarkName setObject:content.page forKey:@"page"];
    [bookmarkName setObject:@"" forKey:@"description"];
    
    NSString *nibName = NULL;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		nibName = @"BookmarkNameController";
	}else {
		nibName = @"BookmarkNameController-iPad";
	}
    
    BookmarkNameController *markName = [[BookmarkNameController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    markName.bookMark = bookmarkName;

    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:markName];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

	if (buttonIndex == 1) {
		UITextView *myText = (UITextView *)[alertView viewWithTag:100];
		[self insertBookMark:myText.text];
	
	}
}
- (void) translateClicked:(id) sender {
    // called when Item clicked in menu
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"languageCode"];
    NSLog(@"%@",myString);
	NSRange range = [textView selectedRange];
	NSString *str = [textView.text substringWithRange:range];
	[translator doTranslate:str FromLang:@"ar" ToLang:myString];
}

- (void) twitteClicked:(id) sender {
    // called when Item clicked in menu
	/*
	BOOL twitter = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://twitter.com/direct_messages/create/twitterusername"]];
	if (twitter) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/direct_messages/create/twitterusername"]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/username"]];
	}
     */
    UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
    
    NSRange range = [self.textView selectedRange];
    NSString *str = [self.textView.text substringWithRange:range];
    
    NSMutableDictionary * feedBak = [[[NSMutableDictionary alloc ] init]autorelease ];
    
    [feedBak setObject:deviceUDID forKey:@"phoneId"];
    [feedBak setObject:TOCinfo.bookId forKey:@"bookId"];
    [feedBak setObject:TOCinfo.indexId forKey:@"indexId"];
    [feedBak setObject:str forKey:@"selectedText"];
    
    NSString *nibName = NULL;
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		nibName = @"FeedbackViewController";
	}else {
		nibName = @"FeedbackViewController-iPad";
	}
    
    FeedbackViewController *feedback = [[FeedbackViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    feedback.feedBack  = feedBak;
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:feedback];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
}

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(bookMarkClicked:) || selector == @selector(translateClicked:) || selector == @selector(twitteClicked:)|| selector == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) prepareToolbars {
	
	next.target = self; 
	next.action = @selector(nextPage:);
	
	previous.target = self;
	previous.action = @selector(previousPage:);
	contentInfo = [contents objectAtIndex:pageIndex];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSString
	NSString *size = [prefs stringForKey:@"fontSize"];
       NSData *colorData = [prefs objectForKey:@"colorCode"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
  
    NSLog(@"%@",color);
    [textView setFont:[UIFont fontWithName:@"Helvetica" size:[size intValue]]];
    [textView setTextColor:color];
    //[textView scrollRangeToVisible:NSMakeRange(0, 0)];
    [textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    //textView.text = @"";
	textView.text = contentInfo.verse;
    //textView.contentInset = UIEdgeInsetsZero;
    //textView.contentSize = CGSizeZero;
	pager.title = [NSString stringWithFormat:@"%i / %i", pageIndex+1, [contents count]];
}

- (void)nextPage:(id)sender
{
	
	pageIndex++;
	if (pageIndex >= [contents count])
	{
		pageIndex = [contents count]-1;
	}
    [textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	contentInfo = [contents objectAtIndex:pageIndex];
	textView.text = contentInfo.verse;
	pager.title = [NSString stringWithFormat:@"%i / %i", pageIndex+1, [contents count]];
}

- (void)previousPage:(id)sender
{
	pageIndex--;
	if (pageIndex < 0)
	{
		pageIndex = 0;
	}
    [textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	contentInfo = [contents objectAtIndex:pageIndex];
	textView.text = contentInfo.verse;
	pager.title = [NSString stringWithFormat:@"%i / %i", pageIndex+1, [contents count]];
}

- (void)fetchBookTOC:(NSString *)bookID
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:[bookID stringByAppendingString:@".sqlite"]];
	
	
	NSString *query = [NSString stringWithFormat:
					 @"SELECT nass,part,id, page FROM b%@ WHERE id>=%@ AND id<=%@",
					 bookID, startID, endID];
	
	if ([startID isEqualToString:endID])
	{
		query = [NSString stringWithFormat:
			   @"SELECT nass,part,id, page FROM b%@ WHERE id=%@",
			   bookID, startID];		
	}
	
	
	[db closeDB];
	
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *dbConnection= [db openDb:pathToDb];
	
	const char *sql = [query UTF8String];
	
	BOOL done = NO;
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(selectstmt) == SQLITE_ROW && !done) {
			
			NSString *verse =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			NSString *part = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
			NSString *verseId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
			NSString *pageNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
			
			BookContent *bookContent = [[BookContent alloc] bookWithId:bookID Verse:verse VerseID:verseId Part:part Page:pageNo]; 
			
			[contents addObject:bookContent];
			[bookContent release];
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
	
	[pool release];
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [bookTitle release];
    [startID release];
    [endID release];
    [TOCinfo release] ;
    [isBookMark release];
    [bookMark release];
    [super dealloc];
}


@end
