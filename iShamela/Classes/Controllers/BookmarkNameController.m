//
//  BookmarkNameController.m
//  iShamela
//
//  Created by Imran Bashir on 1/7/12.
//  Copyright (c) 2012 Aza Studios. All rights reserved.
//

#import "BookmarkNameController.h"

@implementation BookmarkNameController
@synthesize bMarkName, bMarkDescription, okButton, cancelButton, bookMark;
@synthesize bmarkName, bmarkDescription, desc, editBookMark;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
/*
- (void)drawRectCGRect)rect {
    printf("drawRect()\n");
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 3.0); //or whatever width you want
    CGContextSetRGBStrokeColor(currentContext, 0.0, 0.0, 0.0, 1.0); 
    
    CGRect myRect = CGContextGetClipBoundingBox(currentContext);
    //printf("rect = %f,%f,%f,%f\n", myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height);
    
    CGContextStrokeRect(currentContext, myRect);
    UIImage *backgroundImage = (UIImage *)UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [myImageView setImage:backgroundImage];
    [self addSubview:myImageView];
    [backgroundImage release];
    
    UIGraphicsEndImageContext();
}
 
 */
#pragma mark - View lifecycle
-(void) viewWillAppear:(BOOL)animated{
    if ([editBookMark isEqualToString:@"YES"]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editButtonPressed)] autorelease];
    }else{
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(okButtonPressed)] autorelease];
    }
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)] autorelease];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [bmarkName setBorderStyle:UITextBorderStyleRoundedRect];
    bmarkName.enabled = NO;
       
    [bmarkDescription setBorderStyle:UITextBorderStyleRoundedRect];
    bmarkDescription.enabled = NO;
    
    NSLog(@"%@",bookMark);
    db = [[DbManager alloc]  init];
    bMarkName.tag =1;
    bMarkName.textAlignment = UITextAlignmentLeft;
    bMarkName.text = [bookMark objectForKey:@"bookmarkTitle"];
    
    bMarkDescription.tag = 2;
    bMarkDescription.textAlignment = UITextAlignmentLeft;
    bMarkDescription.text = [bookMark objectForKey:@"description"];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)bkTouched:(id)sender{
    
    [self.bMarkName resignFirstResponder];
    [self.bMarkDescription resignFirstResponder];
}
-(void) editButtonPressed{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if ([bMarkName.text isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"BookMark"  message:@"Book Mark Title Cann't be NULL" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil] autorelease];
        [alert show];
    }else{
        NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
        
        [pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
        [pathToDb appendString:@"BookMark.sqlite"];
        
        NSLog(@"%@",pathToDb);
        
        
        NSString *query = [NSString stringWithFormat:
                           @"UPDATE main set indexName = ?, description = ? where id = ?"];
        
        sqlite3_stmt *selectstmt = NULL;
        
        sqlite3 *database;
        
        if(sqlite3_open([pathToDb UTF8String], &database) == SQLITE_OK) {
            
            sqlite3 *dbConnection= [db openDb:pathToDb];
            
            const char *sql = [query UTF8String];
            if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
                NSLog(@"record updated");
                sqlite3_bind_text(selectstmt, 1, [bMarkName.text UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(selectstmt, 2, [bMarkDescription.text UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(selectstmt, 3, [[bookMark objectForKey:@"bookMarkId"] UTF8String], -1, SQLITE_TRANSIENT);
                
                if(SQLITE_DONE != sqlite3_step(selectstmt)){
                    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                }else{
                    //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
                    NSLog(@"record inserted");
                }
                //Reset the add statement.
                sqlite3_reset(selectstmt);
            }
        }
    }
    [pool release];
    [self dismissModalViewControllerAnimated:YES];
}
-(void) okButtonPressed{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if ([bMarkName.text isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"BookMark"  message:@"Book Mark Title Cann't be NULL" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil] autorelease];
        [alert show];
    }else{
	NSMutableString *pathToDb = [[[NSMutableString alloc] init] autorelease];
	
	[pathToDb appendString:[[DbManager getManifestsPath] stringByAppendingFormat:@"/"]];
	[pathToDb appendString:@"BookMark.sqlite"];
	
	NSLog(@"%@",pathToDb);
	
	
	NSString *query = [NSString stringWithFormat:
					   @"INSERT INTO main (bookId,indexName,indexLevel,indexId,nass,nassId,part,pageNo,description) VALUES(?,?,?,?,?,?,?,?,?)"];
	
	sqlite3_stmt *selectstmt = NULL;
	
	sqlite3 *database;
	
	if(sqlite3_open([pathToDb UTF8String], &database) == SQLITE_OK) {
		
		sqlite3 *dbConnection= [db openDb:pathToDb];
		
		const char *sql = [query UTF8String];
		
		if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			NSLog(@"record inserted");
			sqlite3_bind_text(selectstmt, 1, [[bookMark objectForKey:@"bookId"] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 2, [bMarkName.text UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 3, [[bookMark objectForKey:@"indexLevel"] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 4, [[bookMark objectForKey:@"indexId"] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 5, [[bookMark objectForKey:@"verse"] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 6, [[bookMark objectForKey:@"verseId"] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 7, [[bookMark objectForKey:@"part"] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(selectstmt, 8, [[bookMark objectForKey:@"page"] UTF8String], -1, SQLITE_TRANSIENT);
           // if ([bMarkDescription.text isEqualToString:@""]) {
            //        bMarkDescription.text = @"no description";
            //}
			sqlite3_bind_text(selectstmt, 9, [bMarkDescription.text UTF8String], -1, SQLITE_TRANSIENT);
			
			
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
    }
	[pool release];
    [self dismissModalViewControllerAnimated:YES];

}

-(void)cancelButtonPressed{
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark textview delegate
/*- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}*/

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView.tag == 2) {
        CGRect rect = self.view.frame;
        rect.origin.y -= 140;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.tag == 2) {
        CGRect rect = self.view.frame;
        rect.origin.y += 140;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}
@end
