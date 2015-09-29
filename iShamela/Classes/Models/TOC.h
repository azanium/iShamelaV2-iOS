//
//  TOC.h
//  iShamela
//
//  Created by Imran Bashir on 10/3/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TOC : NSObject {
	NSString *bookId;
	NSString *indexTitle;
	NSString *indexLevel;
	NSString *indexSub;
	NSString *indexId;
}


@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *indexTitle;
@property (nonatomic, copy) NSString *indexLevel;
@property (nonatomic, copy) NSString *indexSublevel;
@property (nonatomic, copy) NSString *indexId;

-(id)initWithId: (NSString *)bookID Title: (NSString *)title Level: (NSString *)level Sub: (NSString *)sub Id:(NSString *)ID;

@end
