//
//  BookInfo.h
//  iShamela
//
//  Created by Suhendra Ahmad on 4/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbManager.h"


@interface BookInfo : NSObject {
    NSString *bookId;
    NSString *bookName;
    NSString *bookDetail;
    NSString *bookCategory;
	NSString *bookAuther;
	BOOL selected;
	
}

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookDetail;
@property (nonatomic, copy) NSString *bookCategory;
@property (nonatomic, copy) NSString *bookAuther;
@property (nonatomic, assign) BOOL selected;

+ (BookInfo *)bookWithTitle:(NSString *)_bkId name:(NSString *)_bkName detail:(NSString *)_bkDetail category:(NSString *)_bkCategory auther:(NSString*)_auther;
+(BookInfo *)bookWithManifest:(NSString *)_filename;


@end
