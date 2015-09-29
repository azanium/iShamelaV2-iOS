//
//  LangData.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LangData : NSObject {
	NSString *langCode;
	NSString *langText;
	BOOL selected;
}

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *langCode;
@property (nonatomic, copy) NSString *langText;

+ (LangData *)langWithCode:(NSString *)code LangText:(NSString *)text;

@end
