//
//  BookInfo.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "BookInfo.h"
#import "NSDictionary+Extensions.h"

@implementation BookInfo

@synthesize bookId, bookName, bookDetail, bookCategory, bookAuther, selected;

+ (BookInfo *)bookWithTitle:(NSString *)_bkId name:(NSString *)_bkName detail:(NSString *)_bkDetail category:(NSString *)_bkCategory auther:(NSString*)_auther
{
    BookInfo *book = [[[BookInfo alloc] init] autorelease];
    
    book.bookId = _bkId;
    book.bookName = _bkName;
    book.bookDetail = _bkDetail;
    book.bookCategory = _bkCategory;
	book.bookAuther = _auther;
    
    return book;
}

+(BookInfo *)bookWithManifest:(NSString *)_filename
{
    DbManager *db = [[[DbManager alloc] init] autorelease];
	[db setDelegate:self];
	
	NSMutableDictionary *dic = [db fetchBookinfo:_filename Query:@"select Bkid, Bk, Betaka, cat, Auth from Main"];
 	
	
    if ([dic count] > 0)
    {
        NSString *bkId = [dic objectForKey:@"bookId"];
        NSString *bkName = [dic objectForKey:@"bookName"];
        NSString *bkDetail = [dic objectForKey:@"bookDetail"];
        NSString *bkCategoty = [dic objectForKey:@"bookCategory"];
		NSString *bkAuther = @"";
		if ([dic objectForKey:@"bookAuther"]) {
			bkAuther = [dic objectForKey:@"bookAuther"];
		}
		
        
        BookInfo *book = [BookInfo bookWithTitle:bkId name:bkName detail:bkDetail category:bkCategoty auther:bkAuther];
        
        return book;
    }

    return nil;
}

@end
