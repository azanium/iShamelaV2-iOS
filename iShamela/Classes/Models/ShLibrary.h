//
//  ShLibrary.h
//  iShamela
//
//  Created by Suhendra Ahmad on 4/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"    
#import "BookInfo.h"    
#import "DbManager.h"

@interface ShLibrary : NSObject {
    NSMutableArray *bookCategories;
    NSMutableDictionary *mapCatOrdToCategory;
    
    NSMutableArray *bookList;
}

@property (nonatomic, retain) NSMutableArray *bookCategories;
@property (nonatomic, retain) NSMutableDictionary *mapCatOrdToCategory;
@property (nonatomic, retain) NSMutableArray *bookList;

+ (ShLibrary *)sharedLibrary;
- (void)reloadBooks;

@end
