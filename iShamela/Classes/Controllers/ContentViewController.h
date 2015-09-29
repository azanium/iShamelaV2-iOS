//
//  ContentViewController.h
//  iShamela
//
//  Created by Imran Bashir on 10/16/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookContent.h"
#import "BookInfo.h"
#import "TOC.h"
#import "DbManager.h"
#import "Translator.h"
#import "LangData.h"
#import "BookMark.h"
#import "BookmarkNameController.h"
#import "FeedbackViewController.h"

@interface ContentViewController : UIViewController <UITextViewDelegate, TranslatorDelegate>{
	
	NSString *bookTitle;
	NSString *startID;
	NSString *endID;
	NSMutableArray *contents;
	NSInteger pageIndex;

	BookContent *contentInfo;
	DbManager *db;
	TOC *TOCinfo;
	Translator *translator;
	BookMark *bookMark;
	
	NSString *isBookMark;
	
	UITextView *textView;
	UIBarButtonItem *next;
	UIBarButtonItem *previous;
	UIBarButtonItem *pager;

}
@property (nonatomic, retain) NSString *isBookMark;
@property (nonatomic, retain) NSString *bookTitle;
@property (nonatomic, retain) NSString *startID;
@property (nonatomic, retain) NSString *endID;
@property (nonatomic, retain) TOC *TOCinfo;
@property (nonatomic, retain) BookMark *bookMark;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *next;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *previous;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pager;

- (void) fetchBookMarked;
- (void) editBookmark;
- (void) fetchBookTOC:(NSString *)bookID;
- (void) prepareToolbars;
- (void) nextPage:(id)sender;
- (void) previousPage:(id)sender;
@end
