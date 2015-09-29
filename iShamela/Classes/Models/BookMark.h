//
//  BookMark.h
//  iShamela
//
//  Created by Imran Bashir on 10/24/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookMark : NSObject {
	
    NSString *bookMarkId;
	NSString *bookId;
	NSString *indexName;
	NSString *indexLevel;
	NSString *indexId;
	NSString *nass;
	NSString *nassId;
	NSString *part;
	NSString *pageNo;
    NSString *description;
}

@property (nonatomic, copy) NSString *bookMarkId;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *indexName;
@property (nonatomic, copy) NSString *indexLevel;
@property (nonatomic, copy) NSString *indexId;
@property (nonatomic, copy) NSString *nass;
@property (nonatomic, copy) NSString *nassId;
@property (nonatomic, copy) NSString *part;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *description;

- (id) bookMarkWithId:(NSString *)bookmarkid BookId:(NSString *)bookid indexName:(NSString *)indexname indexLevel:(NSString *)indexlevel 
			  indexId:(NSString *) indexid nass:(NSString *)verse nassId:(NSString *)verseid Part: (NSString *)Part PageNo: (NSString *)Page Description:(NSString *)des;

@end
