//
//  TermsConditionsViewConrtroller.m
//  iShamela
//
//  Created by Imran Bashir on 1/25/12.
//  Copyright (c) 2012 Aza Studios. All rights reserved.
//

#import "TermsConditionsViewConrtroller.h"

@implementation TermsConditionsViewConrtroller


@synthesize termsConditions, termsconditions;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [termsconditions setBorderStyle:UITextBorderStyleRoundedRect];
    termsconditions.enabled = NO;
    termsConditions.scrollEnabled =YES;
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
