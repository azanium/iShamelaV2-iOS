//
//  TOC.m
//  iShamela
//
//  Created by Imran Bashir on 10/3/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "TOC.h"
#import "DbManager.h"

@implementation TOC

@synthesize bookId, indexTitle, indexLevel, indexSublevel, indexId;


- (id)initWithId: (NSString *)bookID Title: (NSString *)title Level: (NSString *)level Sub: (NSString *)sub Id:(NSString *)ID {
	
	//TOC *toc = [[TOC alloc] init];
	
	self.bookId = bookID;
	self.indexTitle = title; 
	self.indexLevel = level;
	self.indexSublevel= sub;
	self.indexId = ID;
	
	
	return self;
}

- (void) dealloc {
	
	[bookId release];
	[indexTitle release];
	[indexLevel release];
	[indexSub release];
	[indexId release];
	
	[super dealloc];
}

@end
