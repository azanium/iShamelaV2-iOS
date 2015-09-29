//
//  ShLibrary.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "ShLibrary.h"
#import "NSDictionary+Extensions.h"
#import "SSZipArchive.h"

@implementation ShLibrary

@synthesize bookCategories;
@synthesize mapCatOrdToCategory;
@synthesize bookList;

+ (ShLibrary *)sharedLibrary
{
    static ShLibrary *_shLibrary = nil;
    
    @synchronized(self)
    {
        if (_shLibrary == nil)
        {
            _shLibrary = [[ShLibrary alloc] init];
        }
    }
    
    return _shLibrary;
}


#pragma mark -
#pragma mark Memory Allocations

- (void)prepare
{
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plist])
    {
        NSData *data = [NSData dataWithContentsOfFile:plist];
        
        if ([data length] > 0)
        {
            NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
            NSMutableArray *array = [NSPropertyListSerialization propertyListFromData:data
                                                                     mutabilityOption:NSPropertyListImmutable format:&format
                                                                     errorDescription:NULL];
            if ([array count] > 0)
            {
                [self.bookCategories removeAllObjects];
                [self.mapCatOrdToCategory removeAllObjects];
                
                for (NSDictionary *dic in array)
                {
                    NSString *catorder =[NSString stringWithFormat:@"%d",[dic intForKey:@"catord"]];
                    NSString *catid = [NSString stringWithFormat:@"%d",[dic intForKey:@"id"]];
                    NSString *level = [NSString stringWithFormat:@"%d",[dic intForKey:@"lvl"]];
                    NSString *name = [dic objectForKey:@"name"];
                    
                    Category *category = [Category categoryWithId:catid 
                                                           catOrd:catorder
                                                            level:level 
                                                             name:name];
                    [self.bookCategories addObject:category];
                    [self.mapCatOrdToCategory setObject:category forKey:[NSString stringWithFormat:@"%i", catorder]];
                }
            }
        }
    }
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	
	NSLog(@"Creating editable copy of database");
	// First, test for existence.
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *manifestPath = [DbManager getManifestsPath];
	NSError *error;
	
	NSString *writableDBPath = [manifestPath stringByAppendingPathComponent:@"BookMark.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [DbManager getUserDocumentPathWithFileName:@"BookMark.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (void)reloadBooks
{   
    NSArray *books = [DbManager fetchAllBooks];
    

    NSString *manifestPath = [DbManager getManifestsPath];
	
	
	
    
    for (NSString *book in books)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
      /*  if ([fileManager fileExistsAtPath:[manifestPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", book]]] == NO)
        {
        
            [SSZipArchive unzipFileAtPath:[DbManager getUserDocumentPathWithFileName:book] 
                             withFileName:@"Manifest.plist"
                            toDestination:[DbManager getManifestsPath]
                               toFileName:[NSString stringWithFormat:@"%@.plist", book]
                                    error:&error];
            NSLog(@"Extractng manifest for book %@", book);
        }
        else
        {
           NSLog(@"Manifest: %@.plist already exists", book);
        }
		*/
		
		NSRange end = [book rangeOfString:@"."];
		NSString *myBook =[book substringWithRange:NSMakeRange(0, end.location)];
		
		if ([fileManager fileExistsAtPath:[manifestPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", myBook]]] == NO)
        {
			
			
			
			
            [SSZipArchive unzipFileAtPath:[DbManager getUserDocumentPathWithFileName:book] 
                             withFileName:[NSString stringWithFormat:@"%@.aza",myBook]
                            toDestination:[DbManager getManifestsPath]
                               toFileName:[NSString stringWithFormat:@"%@.sqlite", myBook]
                                    error:&error];
		
          //  NSLog(@"Extractng db for book %@", book);
        }
        else
        {
          //  NSLog(@"db: %@.sqlite already exists", myBook);
        }
		
	}

    NSArray *manifests = [DbManager fetchAllManifests];

    if ([manifests count] > 0)
    {
        [self.bookList removeAllObjects];

        for (NSString *manifest in manifests)
        {
                     
            // Only process plist file
            NSString *ext = [manifest pathExtension];
            if ([[ext lowercaseString] compare:@"sqlite"] == NSOrderedSame)
            {
                BookInfo *bookinfo = [BookInfo bookWithManifest:[manifestPath stringByAppendingPathComponent:manifest]];
                
                if (bookinfo) {
					[self.bookList addObject:bookinfo];
				}
				
            }
            
        }
    }
    
    NSLog(@"BookList Count %i", [self.bookList count]);
	[self createEditableCopyOfDatabaseIfNeeded];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.bookCategories = [[NSMutableArray alloc] init];
        self.mapCatOrdToCategory = [[NSMutableDictionary alloc] init];
        self.bookList = [[NSMutableArray alloc] init];
        
        [self prepare];
    }
    return self;
}

- (void)dealloc
{
    [bookCategories release];
    [mapCatOrdToCategory release];
    [bookList release];
    
    [super dealloc];
}


@end
