//
//  BookMark.m
//  iShamela
//
//  Created by Imran Bashir on 10/24/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "BookMark.h"


@implementation BookMark

@synthesize bookMarkId, bookId, indexName, indexLevel, indexId, nass, nassId, part, pageNo, description;

- (id) bookMarkWithId:(NSString *)bookmarkid BookId:(NSString *)bookid indexName:(NSString *)indexname indexLevel:(NSString *)indexlevel 
			  indexId:(NSString *) indexid nass:(NSString *)verse nassId:(NSString *)verseid Part: (NSString *)Part PageNo: (NSString *)Page Description:(NSString *)des{
	
	
	BookMark *bookMark = [[BookMark alloc] init];
    
	bookMark.bookMarkId = bookmarkid;
	bookMark.bookId = bookid;
	bookMark.indexName = indexname;
	bookMark.indexLevel = indexlevel;
	bookMark.indexId = indexid;
	bookMark.nass = verse;
	bookMark.nassId = verseid;
	bookMark.part = Page;
	bookMark.pageNo = Page;
    bookMark.description = des;
	
	return bookMark;
 	
}

- (void) dealloc 
{
	
    [bookId release];
	[indexName release];
	[indexLevel release];
	[indexId release];
	[nass release];
	[nassId release];
	[part release];
	[pageNo release];
	[super dealloc];
	
}

@end
