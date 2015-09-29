//
//  BookContent.h
//  iShamela
//
//  Created by Imran Bashir on 10/16/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookContent : NSObject {
	NSString *bookId;
	NSString *verse;
	NSString *verseID;
	NSString *part;
	NSString *page;
}

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *verse;
@property (nonatomic, copy) NSString *verseID;
@property (nonatomic, copy) NSString *part;
@property (nonatomic, copy) NSString *page;

- (id) bookWithId: (NSString *)BookId Verse:(NSString *)Verse VerseID:(NSString *)VerseID Part: (NSString *)Part Page: (NSString *)Page;


@end
