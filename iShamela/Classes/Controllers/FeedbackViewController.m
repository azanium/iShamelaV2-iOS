//
//  FeedbackViewController.m
//  iShamela
//
//  Created by Imran Bashir on 1/10/12.
//  Copyright (c) 2012 Aza Studios. All rights reserved.
//

#import "FeedbackViewController.h"

@implementation FeedbackViewController

@synthesize feedBackTitle, feedBackNote, fBackNote, fBackTitle, okButton, cancelButton;
@synthesize feedBack;

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

#pragma mark - View lifecycle

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(okButtonPressed)] autorelease];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)] autorelease];


    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",feedBack);
    questionSend = false;
    
    [fBackTitle setBorderStyle:UITextBorderStyleRoundedRect];
    fBackTitle.enabled = NO;
    
    [fBackNote setBorderStyle:UITextBorderStyleRoundedRect];
    fBackNote.enabled = NO;
    
    feedBackTitle.tag =1;
    feedBackTitle.textAlignment = UITextAlignmentLeft;
    feedBackTitle.text = @"";
    
    feedBackNote.tag = 2;
    feedBackNote.textAlignment = UITextAlignmentLeft;
    feedBackNote.text = [feedBack objectForKey:@"selectedText"];
}
-(IBAction)bkTouched:(id)sender{
    
    [self.feedBackTitle resignFirstResponder];
    [self.feedBackNote resignFirstResponder];
}

-(void)cancelButtonPressed{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)okButtonPressed{
    
    
    NSURL * url = [NSURL URLWithString:@"http://ishamela.com/feedback.php"];

    
    request = [ASIFormDataRequest requestWithURL:url];
    
   // [request setRequestDidFinishSelector:@selector(bookFetchComplete:)];
   // [request setRequestDidFailSelector:@selector(bookFetchFailed:)];
	
    [request setPostValue:[feedBack objectForKey:@"phoneId"] forKey:@"UIDPHONE"];
    [request setPostValue:[feedBack objectForKey:@"bookId"] forKey:@"BOOKID"];
    [request setPostValue:[feedBack objectForKey:@"indexId"] forKey:@"TOCID"];
    [request setPostValue:self.feedBackNote.text forKey:@"COMMENT"];
    [request setPostValue:[feedBack objectForKey:@"selectedText"] forKey:@"TXTSELECTED"];
    [request setDelegate:self];
    
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    
    [request startAsynchronous];

  //  NSString *response = [request responseString];
    
    
}

- (void)requestDone:(ASIHTTPRequest *)Request
{
    NSString *response = [Request responseString];
    NSLog(@"%@",response);
    if (![response isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Your question is sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
        [alert show];
        [alert release];
        questionSend = true;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Network error, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
        [alert show];
        [alert release];
        questionSend = false;
    }
    
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (questionSend == true) {
        [self dismissModalViewControllerAnimated:YES];
    }else{
        
    }

}
- (void)requestWentWrong:(ASIHTTPRequest *)Request
{
    NSError *error = [Request error];
    NSLog(@"%@",error);
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

@end
