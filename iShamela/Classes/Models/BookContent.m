//
//  BookContent.m
//  iShamela
//
//  Created by Imran Bashir on 10/16/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "BookContent.h"


@implementation BookContent

@synthesize bookId, verse, verseID, part, page;

- (id) bookWithId: (NSString *)BookId Verse:(NSString *)Verse VerseID:(NSString *)VerseID Part: (NSString *)Part Page: (NSString *)Page
{		
	BookContent *book = [[BookContent alloc] init];
		
	book.bookId = BookId;
	book.verse = Verse;
	book.part = Part;
	book.page = Page;
	book.verseID = VerseID;
		
	return book;
}
	
- (void) dealloc 
{
	[bookId release];
	[verse release];
	[page release];
	[part release];
	[verseID release];
		
	[super dealloc];
}
@end
