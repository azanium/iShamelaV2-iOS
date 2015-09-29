//
//  CounterViewController.h
//  iShamela
//
//  Created by Imran Bashir on 12/27/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CounterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{

	UITableView *aTableView;
	NSMutableArray *counter;
    NSMutableString *accessType;
    NSMutableArray *languageCode;
    NSMutableArray *colorCode;
	
}

@property (nonatomic, retain) IBOutlet UITableView *aTableView;
@property (nonatomic, retain) NSMutableString *accessType;

@end
