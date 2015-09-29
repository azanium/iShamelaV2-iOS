//
//  SettingsViewController.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/4/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "SettingsViewController.h"
#import "CounterViewController.h"
#import "AboutUsViewController.h"
#import "TermsConditionsViewConrtroller.h"

@implementation SettingsViewController


@synthesize aTableView;

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
    [super dealloc];
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
	
	settings = [[NSMutableArray alloc] init];
	
	[settings addObject:@"About us"];
	[settings addObject:@"Terms & Conditions"];
	[settings addObject:@"NOs of lines"];
    [settings addObject:@"NOs of search result"]; 
    [settings addObject:@"Font size"];
    [settings addObject:@"Font color"];
	
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
	return [settings count];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    	
    // Configure the cell...
    cell.textLabel.text = [settings objectAtIndex:indexPath.row];
	
		
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	if ([[settings objectAtIndex:indexPath.row] isEqualToString: @"NOs of lines"]) {
		
		NSString *nibName = NULL;
		
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		{
			nibName = @"CounterViewController";
		}else {
			nibName = @"CounterViewController-iPad";
		}
		
		
		CounterViewController *CounterView = [[CounterViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
        CounterView.accessType = [NSMutableString stringWithString:@"rowCounter"];
		[self.navigationController pushViewController:CounterView animated:YES];
	}else{
        
        if ([[settings objectAtIndex:indexPath.row] isEqualToString: @"NOs of search result"]) {
            
            NSString *nibName = NULL;
            
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
            {
                nibName = @"CounterViewController";
            }else {
                nibName = @"CounterViewController-iPad";
            }
            
            
            CounterViewController *CounterView = [[CounterViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
            CounterView.accessType = [NSMutableString stringWithString:@"searchCounter"];
            [self.navigationController pushViewController:CounterView animated:YES];
            [CounterView release];
        }else{
            if ([[settings objectAtIndex:indexPath.row] isEqualToString: @"About us"]) {
                NSString *nibName = NULL;
                
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                {
                    nibName = @"AboutUsViewController";
                }else {
                    nibName = @"AboutUsViewController-iPad";
                }
                
                
                AboutUsViewController *AboutUsView = [[AboutUsViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:AboutUsView animated:YES];
                [AboutUsView release];
            }else{
                if ([[settings objectAtIndex:indexPath.row] isEqualToString: @"Terms & Conditions"]) {
                    NSString *nibName = NULL;
                    
                    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                    {
                        nibName = @"TermsConditionsViewConrtroller";
                    }else {
                        nibName = @"TermsConditionsViewConrtroller-iPad";
                    }
                    
                    
                    TermsConditionsViewConrtroller *TermsConditionsView = [[TermsConditionsViewConrtroller alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
                    [self.navigationController pushViewController:TermsConditionsView animated:YES];
                    [TermsConditionsView release];
                }else{
                    if ([[settings objectAtIndex:indexPath.row] isEqualToString:@"Font size"]) {
                        NSString *nibName = NULL;
                        
                        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                        {
                            nibName = @"CounterViewController";
                        }else {
                            nibName = @"CounterViewController-iPad";
                        }
                        
                        
                        CounterViewController *CounterView = [[CounterViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
                        CounterView.accessType = [NSMutableString stringWithString:@"fontSize"];
                        [self.navigationController pushViewController:CounterView animated:YES];
                        [CounterView release];

                    }else{
                        if ([[settings objectAtIndex:indexPath.row] isEqualToString:@"Font color"]) {
                            NSString *nibName = NULL;
                            
                            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                            {
                                nibName = @"CounterViewController";
                            }else {
                                nibName = @"CounterViewController-iPad";
                            }
                            
                            
                            CounterViewController *CounterView = [[CounterViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
                            CounterView.accessType = [NSMutableString stringWithString:@"fontColor"];
                            [self.navigationController pushViewController:CounterView animated:YES];
                            [CounterView release];
                            
                        }
                    }
                }
            }
        }
    }
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
}	
		
@end
