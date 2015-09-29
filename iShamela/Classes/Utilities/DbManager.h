//
//  DbManager.h
//  iShamela
//
//  Created by Suhendra Ahmad on 4/4/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class DbManager;

@protocol DBManagerDelegate <NSObject>

@optional
- (void)dbPrepare:(DbManager *)manager;
- (BOOL)dbGotRecord:(DbManager *)manager Statement:(sqlite3_stmt *)stmt Object:(NSObject *)obj;
- (void)dbFinalize:(DbManager *)manager;

- (BOOL)dbGotBookInfoRecord:(DbManager *)manager Statement:(sqlite3_stmt *)stmt;

@end

@interface DbManager : NSObject {
    NSMutableArray *books;
	sqlite3 *dbConnection;
	
	id <DBManagerDelegate> delegate;
	
	NSString *dbFileName;
	BOOL stopFetch;
	
}

@property (nonatomic, retain) NSMutableArray *books;
@property (nonatomic, assign) BOOL stopFetch;
@property (nonatomic, copy) NSString *dbFileName;
@property (nonatomic, assign) id <DBManagerDelegate> delegate;


// Static Methods
+ (DbManager *)defaultManager;
+ (NSString *)getTempBookPath;
+ (NSString *)getUserDocumentPath;
+ (NSString *)getManifestsPath;
+ (NSString *)getUserDocumentPathWithFileName:(NSString *)filename;

// File Management
+ (void)copyAttachedBook: (NSString *)filename;
+ (void)duplicateAttachedBooks;
+ (NSArray *)fetchAllBooks;
+ (NSArray *)fetchAllManifests;

// Instance Methods
- (sqlite3 *)openDb:(NSString *)filename;
- (void)closeDB;
- (NSMutableDictionary *)fetchBookinfo:(NSString *)filename Query:(NSString *)query;

- (NSMutableArray *)fetchBookTOC:(NSString *)filename Query:(NSString *)query;
@end
