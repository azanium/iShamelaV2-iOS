//
//  CounterViewController.m
//  iShamela
//
//  Created by Imran Bashir on 12/27/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "CounterViewController.h"


@implementation CounterViewController

@synthesize aTableView, accessType;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	counter = [[NSMutableArray alloc] init];
    languageCode = [[NSMutableArray alloc] init];
    colorCode = [[NSMutableArray alloc] init ];
	if ([accessType isEqualToString:@"rowCounter"]) {
        
        
        [counter addObject:@"25"];
        [counter addObject:@"50"];
        [counter addObject:@"75"];
        [counter addObject:@"100"];
        [counter addObject:@"150"];
        [counter addObject:@"200"];
        [counter addObject:@"300"];
        [counter addObject:@"400"];
        [counter addObject:@"500"];
        
    }
    if ([accessType isEqualToString:@"searchCounter"]) {
        [counter addObject:@"250"];
        [counter addObject:@"500"];
        [counter addObject:@"750"];
        [counter addObject:@"1000"];
        [counter addObject:@"1500"];
        [counter addObject:@"2000"];
        [counter addObject:@"3000"];
        [counter addObject:@"4000"];
        [counter addObject:@"5000"];
    }
    if ([accessType isEqualToString:@"language"]) {
        [counter addObject:@"English"];
        [counter addObject:@"Danish"];
        [counter addObject:@"German"];
        [counter addObject:@"Swedish"];
        [counter addObject:@"Norwegian"];
        
        [languageCode addObject:@"en"];
        [languageCode addObject:@"da"];
        [languageCode addObject:@"de"];
        [languageCode addObject:@"sv"];
        [languageCode addObject:@"no"];
    }
    
    if ([accessType isEqualToString:@"fontSize"]) {
        [counter addObject:@"12"];
        [counter addObject:@"14"];
        [counter addObject:@"16"];
        [counter addObject:@"18"];
        [counter addObject:@"20"];
        [counter addObject:@"22"];
        [counter addObject:@"24"];
        [counter addObject:@"26"];
        [counter addObject:@"28"];
        [counter addObject:@"30"];
        
    }
    if ([accessType isEqualToString:@"fontColor"]) {
        [counter addObject:@"Black Color"];
        [counter addObject:@"White Color"];
        [counter addObject:@"Gray Color"];
        [counter addObject:@"Red Color"];
        [counter addObject:@"Green Color"];
        [counter addObject:@"Blue Color"];
        [counter addObject:@"Cyan Color"];
        [counter addObject:@"Yellow Color"];
        [counter addObject:@"Magenta Color"];
        
        [colorCode addObject:[UIColor blackColor]];
        [colorCode addObject:[UIColor whiteColor]];
        [colorCode addObject:[UIColor grayColor]];
        [colorCode addObject:[UIColor redColor]];
        [colorCode addObject:[UIColor greenColor]];
        [colorCode addObject:[UIColor blueColor]];
        [colorCode addObject:[UIColor cyanColor]];
        [colorCode addObject:[UIColor yellowColor]];
        [colorCode addObject:[UIColor magentaColor]];
        
    }

    
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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [counter count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = [counter objectAtIndex:indexPath.row];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = NULL;
	// getting an NSString
    if ([accessType isEqualToString:@"rowCounter"]) {
        myString = [prefs stringForKey:@"recordCounter"];
    }else{
        if ([accessType isEqualToString:@"searchCounter"]) {
            myString = [prefs stringForKey:@"searchCounter"];
        }else{
            if ([accessType isEqualToString:@"language"]) {
                myString = [prefs stringForKey:@"language"];
            }else{
                if ([accessType isEqualToString:@"fontSize"]) {
                    myString = [prefs stringForKey:@"fontSize"];
                }else{
                    if ([accessType isEqualToString:@"fontColor"]) {
                        myString = [prefs stringForKey:@"fontColor"];
                    }
                }
            }
        }
    }
	
	if ([myString isEqualToString:[counter objectAtIndex:indexPath.row]]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}else{
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
	

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// saving an NSString
    if ([accessType isEqualToString:@"rowCounter"]) {
        [prefs setObject:[counter objectAtIndex:indexPath.row] forKey:@"recordCounter"];
    }else{
        if ([accessType isEqualToString:@"searchCounter"]) {
            [prefs setObject:[counter objectAtIndex:indexPath.row] forKey:@"searchCounter"];
        }else{
            if ([accessType isEqualToString:@"language"]) {
                [prefs setObject:[languageCode objectAtIndex:indexPath.row] forKey:@"languageCode"];
                [prefs setObject:[counter objectAtIndex:indexPath.row] forKey:@"language"];
            }else{
                if ([accessType isEqualToString:@"fontSize"]) {
                    [prefs setObject:[counter objectAtIndex:indexPath.row] forKey:@"fontSize"];
                }else{
                    if ([accessType isEqualToString:@"fontColor"]) {
                        [prefs setObject:[counter objectAtIndex:indexPath.row] forKey:@"fontColor"];
                        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[colorCode objectAtIndex:indexPath.row]];
                        [prefs setObject:colorData forKey:@"colorCode"];

                    }
                }
            }
        }
    }
	
	[prefs synchronize];
	[aTableView reloadData];
	
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

