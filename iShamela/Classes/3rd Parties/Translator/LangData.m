//
//  LangData.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "LangData.h"


@implementation LangData

@synthesize langCode, langText, selected;

+ (LangData *)langWithCode:(NSString *)code LangText:(NSString *)text
{
	LangData *lang = [[LangData alloc] init];
	lang.langCode = code;
	lang.langText = text;
	lang.selected = NO;
	
	return lang;
}

- (void) dealloc
{
	[langCode release];
	[langText release];
	
	[super dealloc];
}

@end
