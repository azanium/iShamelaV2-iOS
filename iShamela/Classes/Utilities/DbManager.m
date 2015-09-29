//
//  DbManager.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/4/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "DbManager.h"
#import <sqlite3.h>

@implementation DbManager

@synthesize books;
@synthesize dbFileName; 
@synthesize stopFetch;
@synthesize delegate;

#pragma mark -
#pragma mark Static Methods

static DbManager *_dbManager = nil;

+ (DbManager *)defaultManager
{
	if (_dbManager == nil) {
		_dbManager = [[[DbManager alloc] init] autorelease];
	}
	
	return _dbManager;
}

+ (NSString *)getTempBookPath
{    
    NSString *temp = [NSTemporaryDirectory() stringByAppendingFormat:@"Books/"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = YES;
    if ([fileManager fileExistsAtPath:temp isDirectory:&isDir] == NO)
    {
        NSError *error;
    
        if ([fileManager createDirectoryAtPath:temp
                   withIntermediateDirectories:NO 
                                    attributes:nil 
                                         error:&error] == NO)
        {
            NSLog(@"DbManager: Failed to create Books tmp directory...");
        };
    }
    return temp;
}

+ (NSString *)getUserDocumentPathWithFileName:(NSString *)filename
{
    return [[DbManager getUserDocumentPath] stringByAppendingPathComponent:filename];
}


+ (NSString *)getUserDocumentPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	
    NSString *newDirectory = [NSString stringWithFormat:@"%@/CompressedBooks", [paths objectAtIndex:0]];
    
    // Check if the directory already exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory]) {
        // Directory does not exist so create it
        [[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
	NSString *Path = [paths objectAtIndex: 0];
    NSString *documentPath = [Path stringByAppendingPathComponent:@"CompressedBooks"];
	
	return documentPath;
}

+ (NSString *)getManifestsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *newDirectory = [NSString stringWithFormat:@"%@/ExtractBooks", [paths objectAtIndex:0]];
    
    // Check if the directory already exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory]) {
        // Directory does not exist so create it
        [[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *libPath = [paths objectAtIndex:0];
    NSString *manifestPath = [libPath stringByAppendingPathComponent:@"ExtractBooks"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = YES;
    if ([fileManager fileExistsAtPath:manifestPath isDirectory:&isDir] == NO)
    {
        NSError *error;
        
        if ([fileManager createDirectoryAtPath:manifestPath
                   withIntermediateDirectories:NO 
                                    attributes:nil 
                                         error:&error] == NO)
        {
            NSLog(@"DbManager: Failed to create Manifests directory...");
        };
    }

    
    return manifestPath;
}

#pragma mark -
#pragma mark File Management

+ (void)copyAttachedBook:(NSString *)filename
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dbPath = [DbManager getUserDocumentPathWithFileName:filename];
	
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	NSError *error;
	    
	if (!success)
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
		{
			NSLog(@"%@",error);
            NSAssert(0, @"copyBuiltInDBFiles: failed to copy builtin db");
		}
	}
}

+ (NSArray *)fetchAllBooks
{
    NSError *error;
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[DbManager getUserDocumentPath]      
                                                               error:&error];
}

+ (NSArray *)fetchAllManifests
{
    NSError *error;
    
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[DbManager getManifestsPath] error:&error];
}

+ (void)duplicateAttachedBooks
{
    NSString *path = [[NSBundle mainBundle] resourcePath];
    
    NSString *targetPath = [DbManager getUserDocumentPath];
    
    NSError *error;
    
    // Find all files inside the main bundle
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (NSString *file in files)
    {
        // Only process azx files, others ignore
        NSString *ext = [file pathExtension];
        if ([[ext lowercaseString] compare:@"azx"] == NSOrderedSame || [[ext lowercaseString] compare:@"sqlite"] == NSOrderedSame)
        {            
            // Only copy the attached books when the doesn't exist yet on the Documents folder
            if ([fileManager fileExistsAtPath:[targetPath stringByAppendingPathComponent:file]] == NO)
            {
                NSLog(@"Copying attached book : %@", file);

                [DbManager copyAttachedBook:file];
            }
            
        }
    }
    
}

#pragma mark -
#pragma mark  SQlite Operations

- (sqlite3 *)openDb:(NSString *)filename 
{
		
	
	[self closeDB];
	
	if (sqlite3_open([filename UTF8String], &dbConnection) != SQLITE_OK)
	{
		NSLog(@"openDB: failed to open database");
		
		return NO;
	}
	
	self.dbFileName = filename;
	
	return dbConnection;
}

- (void)closeDB
{
	if (dbConnection)
	{
		sqlite3_close(dbConnection);
	}
}

- (NSMutableDictionary *)fetchBookinfo:(NSString *)filename Query:(NSString *)query
{
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self closeDB];
	
	sqlite3_stmt *selectstmt = NULL;
	
	[self openDb:filename];
	
	const char *sql = [query UTF8String];
	
	BOOL done = NO;
	NSMutableDictionary *bookinfo = [[[NSMutableDictionary alloc] init] autorelease];
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(selectstmt) == SQLITE_ROW && !done) {
			
			[bookinfo setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)] forKey:@"bookId"];
			[bookinfo setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)] forKey:@"bookName"];
			[bookinfo setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)] forKey:@"bookDetail"];
			[bookinfo setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)] forKey:@"bookCategory"];
			NSString *auth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
			if (auth) {
				[bookinfo setObject:auth forKey:@"bookAuther"];
			}
			
		}
	} else {
		NSLog(@"DBManager:fetchBookInfo: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
	
	//[pool release];
	
	return bookinfo;
}

- (NSMutableArray *)fetchBookTOC:(NSString *)filename Query:(NSString *)query
{
	//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self closeDB];
	
	sqlite3_stmt *selectstmt = NULL;
	
	[self openDb:filename];
	
	const char *sql = [query UTF8String];
	
	BOOL done = NO;
	NSMutableDictionary *bookTOC = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableArray *arrayTOC = [[[NSMutableArray alloc] init] autorelease];
	if (sqlite3_prepare_v2(dbConnection, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(selectstmt) == SQLITE_ROW && !done) {
			
						
			[bookTOC setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)] forKey:@"title"];
			[bookTOC setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)] forKey:@"level"];
			[bookTOC setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)] forKey:@"sublevel"];
			[bookTOC setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)] forKey:@"pageno"];
			
			[arrayTOC addObject:[bookTOC copy]];
		}
	} else {
		NSLog(@"DBManager:fetchRecords: Failed to prepare SQlite3 DB...");
	}
	
	sqlite3_finalize(selectstmt);
	
	//[pool release];
	
	return arrayTOC;
}


@end
